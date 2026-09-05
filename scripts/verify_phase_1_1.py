#!/usr/bin/env python3
"""Static checks for Filekit Phase 1.1 polish. Run from the repo root."""

from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read(relative: str) -> str:
    return (ROOT / relative).read_text(encoding="utf-8")


def fail(message: str) -> None:
    print(f"FAIL: {message}", file=sys.stderr)
    raise SystemExit(1)


def main() -> None:
    sources = [
        ROOT / "README.md",
        *sorted((ROOT / "Shared").glob("*.swift")),
        *sorted((ROOT / "Filekit").glob("*.swift")),
        *sorted((ROOT / "FinderSync").glob("*.swift")),
    ]
    for path in sources:
        for line_no, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
            if "Handy" not in line:
                continue
            allowed = (
                "Never Handy" in line
                or "never Handy" in line
                or "not Handy" in line
                or "not a Handy" in line
            )
            if not allowed:
                fail(f"{path.relative_to(ROOT)}:{line_no} uses Handy as a product name")

    brand = read("Shared/FilekitBrand.swift")
    for needle in (
        '"Filekit ›"',
        '"Copy Path"',
        '"mango studios"',
        "0xFF / 255, green: 0xF9 / 255, blue: 0xED / 255",
        "0x24 / 255, green: 0x21 / 255, blue: 0x1D / 255",
        "0xFF / 255, green: 0xC9 / 255, blue: 0x28 / 255",
        "cornerRadius: CGFloat = 16",
        "outlineWidth: CGFloat = 2",
        "printShadowOffset: CGFloat = 4",
        "reservedBlankRowCount = 3",
        "0xFF / 255, green: 0xE1 / 255, blue: 0x69 / 255",
    ):
        if needle not in brand:
            fail(f"FilekitBrand.swift missing {needle!r}")

    copy_path = read("Shared/FilekitCopyPath.swift")
    if 'joined(separator: "\\n")' not in copy_path:
        fail("Copy Path must join paths with newlines")

    menu = read("Shared/FilekitFinderMenu.swift")
    for needle in (
        "FilekitBrand.parentMenuTitle",
        "FilekitBrand.copyPathTitle",
        "parent.submenu = submenu",
        "FilekitMenuIcon.copyPath()",
    ):
        if needle not in menu:
            fail(f"FilekitFinderMenu.swift missing {needle!r}")

    finder = read("FinderSync/FinderSync.swift")
    if "FilekitFinderMenu.makeContextualMenu" not in finder:
        fail("FinderSync.swift must build the Filekit › menu")
    if "FilekitCopyPath.pasteboardString" not in finder:
        fail("FinderSync.swift must use FilekitCopyPath")
    if "withTitle: \"Copy Path\"" in finder:
        fail("FinderSync.swift still adds a flat Phase 0 Copy Path item")

    icon = read("Shared/FilekitMenuIcon.swift")
    if "roundedRect" not in icon:
        fail("Copy Path icon must be a filled rounded pictogram")
    if "MangoGeometry" in icon:
        fail("Copy Path icon must not use the footer mango stamp")
    if icon.count("ctx.fillPath()") < 2:
        fail("Copy Path pictogram must use 2–5 filled shapes")

    panel = read("Filekit/FilekitStampPanel.swift")
    for needle in (
        "FilekitStampPanel",
        "FilekitMangoFooter",
        "FilekitTheme.mango",
        "BlankReservedRow",
        "reservedBlankRowCount",
        "isHovering ? FilekitTheme.mango : Color.clear",
        "FilekitTheme.fruit",
        "no outline",
    ):
        if needle not in panel:
            fail(f"FilekitStampPanel.swift missing {needle!r}")

    readme = read("README.md")
    for needle in (
        "Phase 1.1 is a draft",
        "blocked on Ash",
        "Finder can vs cannot",
        "Filekit ›",
        "Never Handy",
        "#FFF9ED",
        "#24211D",
        "#FFC928",
        "#FFE169",
        "blank until Jack",
        "filled rounded pictograms",
    ):
        if needle not in readme:
            fail(f"README.md missing {needle!r}")

    pbx = read("Filekit.xcodeproj/project.pbxproj")
    for needle in (
        "FilekitBrand.swift",
        "FilekitCopyPath.swift",
        "MangoGeometry.swift",
        "FilekitMenuIcon.swift",
        "FilekitFinderMenu.swift",
        "FilekitStampPanel.swift",
        "path = Shared",
    ):
        if needle not in pbx:
            fail(f"project.pbxproj missing {needle!r}")

    print("PASS: Phase 1.1 static checks")


if __name__ == "__main__":
    main()
