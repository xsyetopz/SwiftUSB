#!/usr/bin/env python3
"""Synchronize SwiftUSB release-version surfaces."""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
VERSION_PATTERN = re.compile(r"(?:0|[1-9]\d*)\.(?:0|[1-9]\d*)\.(?:0|[1-9]\d*)")


def parse_version(value: str) -> str:
    if VERSION_PATTERN.fullmatch(value) is None:
        raise argparse.ArgumentTypeError("version must be MAJOR.MINOR.PATCH without prefixes")
    return value


def expected_files(version: str) -> dict[Path, str]:
    source = ROOT / "Sources/SwiftUSB/SwiftUSBVersion.swift"
    source_text = source.read_text()
    source_text, count = re.subn(
        r"public static let current = \"[^\"]+\"",
        f"public static let current = \"{version}\"",
        source_text,
    )
    if count != 1:
        raise RuntimeError(f"expected one version declaration in {source}")

    replacements = {ROOT / "VERSION": f"{version}\n", source: source_text}
    for relative in ("README.md", "docs/PUBLISHING.md"):
        path = ROOT / relative
        text = path.read_text()
        text, count = re.subn(
            r"(package\(url: \"https://github\.com/xsyetopz/SwiftUSB\.git\", from: \")[^\"]+(\"\))",
            rf"\g<1>{version}\g<2>",
            text,
        )
        if count != 1:
            raise RuntimeError(f"expected one package version in {path}")
        replacements[path] = text
    return replacements


def changelog_notes(version: str) -> str:
    text = (ROOT / "CHANGELOG.md").read_text()
    match = re.search(
        rf"^## {re.escape(version)}(?: - [^\n]+)?\n\n(?P<body>.*?)(?=^## |\Z)",
        text,
        re.MULTILINE | re.DOTALL,
    )
    if match is None:
        raise RuntimeError(f"CHANGELOG.md has no {version} section")
    body = match.group("body").strip()
    if not body:
        raise RuntimeError(f"CHANGELOG.md {version} section is empty")
    return body + "\n"


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("version", nargs="?", type=parse_version)
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--release-notes", action="store_true")
    args = parser.parse_args()

    version = args.version or (ROOT / "VERSION").read_text().strip()
    version = parse_version(version)
    expected = expected_files(version)

    if args.release_notes:
        sys.stdout.write(changelog_notes(version))
        return 0

    mismatches = [str(path.relative_to(ROOT)) for path, content in expected.items() if path.read_text() != content]
    if args.check:
        if mismatches:
            print("version mismatch: " + ", ".join(mismatches), file=sys.stderr)
            return 1
        changelog_notes(version)
        return 0

    for path, content in expected.items():
        path.write_text(content)
    changelog_notes(version)
    print(f"SwiftUSB version synchronized to {version}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
