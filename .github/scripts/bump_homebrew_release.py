#!/usr/bin/env python3
"""Bump a configured Homebrew formula/cask from a GitHub release."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import sys
from urllib.request import Request, urlopen


TAG_RE = re.compile(r"^v?[0-9]+(?:\.[0-9]+)+(?:[-+][0-9A-Za-z.-]+)?$")
SHA_RE = re.compile(r"^[0-9a-fA-F]{64}$")
VERSION_LINE_RE = re.compile(r'^(\s*version\s+")([^"]+)(".*)$')
URL_LINE_RE = re.compile(r'^(\s*url\s+")([^"]+)(".*)$')
SHA_LINE_RE = re.compile(r'^(\s*sha256\s+")([0-9a-fA-F]{64})(".*)$')


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--config", default=".github/homebrew-bump.json")
    parser.add_argument("--target", required=True)
    parser.add_argument("--tag", required=True)
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    tag = args.tag.strip()
    if not TAG_RE.fullmatch(tag):
        raise SystemExit(f"invalid tag: {tag!r}")
    version = tag[1:] if tag.startswith("v") else tag

    config = json.loads(Path(args.config).read_text(encoding="utf-8"))
    targets = config.get("targets", {})
    if args.target not in targets:
        raise SystemExit(f"unknown target {args.target!r}; configured targets: {', '.join(sorted(targets))}")

    target = targets[args.target]
    path = Path(target["path"])
    if not path.is_file():
        raise SystemExit(f"{path} does not exist")

    sums = checksums_for(target, tag)
    lines = path.read_text(encoding="utf-8").splitlines(keepends=True)
    original = list(lines)

    replace_version(lines, version)

    used_sha_lines: set[int] = set()
    for asset in target["assets"]:
        filename = asset["file"]
        if filename not in sums:
            raise SystemExit(f"{filename} missing from checksum source")
        asset_url = render_asset_url(target, asset, tag, version)
        url_line = replace_url(lines, filename, asset_url, update_url=asset.get("update_url", True))
        sha_line = find_sha_line(lines, url_line, used_sha_lines)
        lines[sha_line] = replace_regex(lines[sha_line], SHA_LINE_RE, sums[filename])
        used_sha_lines.add(sha_line)

    changed = lines != original
    if changed and not args.dry_run:
        path.write_text("".join(lines), encoding="utf-8")

    write_outputs(
        {
            "changed": str(changed).lower(),
            "kind": target["kind"],
            "path": str(path),
            "target": args.target,
            "tag": tag,
            "version": version,
        }
    )

    if changed:
        action = "would bump" if args.dry_run else "bumped"
        print(f"{action} {args.target} to {version} in {path}")
    else:
        print(f"{args.target} is already at {version}")
    return 0


def checksums_for(target: dict, tag: str) -> dict[str, str]:
    assets = target["assets"]
    if checksum_asset := target.get("checksum_asset"):
        url = render_release_url(target, tag, checksum_asset)
        return parse_checksum_file(download(url))

    return {
        asset["file"]: sha256_bytes(download(render_asset_url(target, asset, tag, tag.lstrip("v")), binary=True))
        for asset in assets
    }


def render_asset_url(target: dict, asset: dict, tag: str, version: str) -> str:
    template = asset.get("url_template") or target["asset_url_template"]
    return template.format(
        release_repo=target["release_repo"],
        tag=tag,
        version=version,
        file=asset["file"],
    )


def render_release_url(target: dict, tag: str, filename: str) -> str:
    return f"https://github.com/{target['release_repo']}/releases/download/{tag}/{filename}"


def download(url: str, *, binary: bool = False):
    req = Request(url, headers={"User-Agent": "martona-homebrew-tap-bump"})
    with urlopen(req, timeout=60) as resp:
        data = resp.read()
    return data if binary else data.decode("utf-8")


def parse_checksum_file(text: str) -> dict[str, str]:
    sums: dict[str, str] = {}
    for raw in text.splitlines():
        parts = raw.strip().split()
        if len(parts) < 2:
            continue
        digest, filename = parts[0], Path(parts[-1]).name
        if SHA_RE.fullmatch(digest):
            sums[filename] = digest.lower()
    return sums


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def replace_version(lines: list[str], version: str) -> None:
    for i, line in enumerate(lines):
        if VERSION_LINE_RE.match(line):
            lines[i] = replace_regex(line, VERSION_LINE_RE, version)
            return
    raise SystemExit("no version line found")


def replace_url(lines: list[str], filename: str, url: str, *, update_url: bool) -> int:
    for i, line in enumerate(lines):
        if filename in line and URL_LINE_RE.match(line):
            if update_url:
                lines[i] = replace_regex(line, URL_LINE_RE, url)
            return i
    raise SystemExit(f"no url line found for {filename}")


def find_sha_line(lines: list[str], url_line: int, used: set[int]) -> int:
    candidates = list(range(url_line, min(len(lines), url_line + 12)))
    candidates += list(range(max(0, url_line - 3), url_line))
    for i in candidates:
        if i not in used and SHA_LINE_RE.match(lines[i]):
            return i
    raise SystemExit(f"no sha256 line found near line {url_line + 1}")


def replace_regex(line: str, regex: re.Pattern[str], value: str) -> str:
    body, eol = split_eol(line)
    match = regex.match(body)
    if not match:
        raise SystemExit(f"line did not match expected shape: {line.rstrip()}")
    return f"{match.group(1)}{value}{match.group(3)}{eol}"


def split_eol(line: str) -> tuple[str, str]:
    if line.endswith("\r\n"):
        return line[:-2], "\r\n"
    if line.endswith("\n"):
        return line[:-1], "\n"
    return line, ""


def write_outputs(outputs: dict[str, str]) -> None:
    if output_path := os.environ.get("GITHUB_OUTPUT"):
        with open(output_path, "a", encoding="utf-8") as fh:
            for key, value in outputs.items():
                print(f"{key}={value}", file=fh)


if __name__ == "__main__":
    sys.exit(main())
