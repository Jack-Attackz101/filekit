# Filekit

Filekit is a native macOS Finder utility from Mango Studios.

**Phase 1.1 is a draft.** It is blocked on Ash’s Phase 0 Mac pass ([PR #1](https://github.com/Jack-Attackz101/filekit/pull/1)). Do not merge this polish until Phase 0 Copy Path is confirmed on a Mac. Phase 0 itself is unchanged on its own branch.

Product name is **Filekit**. Never Handy.

## Tess Phase 1.1 pixel lock (Sol stamped)

Exact values. Do not drift.

| Token | Value |
| --- | --- |
| Native parent | **Filekit ›** |
| Panel fill | cream `#FFF9ED` |
| Outline | 2px ink `#24211D` |
| Corners | 16px |
| Print stamp shadow | `4px 4px 0` ink |
| Hover | full-row mango `#FFC928`, ink text |
| Icons | filled rounded pictograms (2–5 shapes) |
| Footer | pale mango `#FFE169` + one detached leaf, no outline |
| First real row | **Copy Path** |
| Other rows | blank until Jack adds actions |
| Product name | Filekit — never Handy |

Copy Path behavior is unchanged from Phase 0: absolute POSIX path(s) to the pasteboard; multiple items joined with newlines. No extra Finder actions.

## Draft until Phase 0 passes

| Gate | Status |
| --- | --- |
| Phase 0 Finder Copy Path on a Mac | Waiting on Ash |
| Merge Phase 1.1 | Blocked |
| Change Phase 0 behavior as the only action | Do not |

If Phase 0 fails, fix Phase 0 first. This branch is polish on top of Copy Path, not a replacement for it.

## Finder can vs cannot

Apple’s Finder Sync API (`FIFinderSync.menu(for:)`) returns an `NSMenu` that **Finder** draws. That is enough for structure and a row icon. It is not enough for handmade chrome.

| Surface | What you get |
| --- | --- |
| **Finder right-click** | Native system menu. Parent **Filekit ›**, one child **Copy Path**, filled rounded pictogram via `NSMenuItem.image` if Finder keeps the bitmap. Finder may also draw its own submenu chevron next to the `›`. |
| **Finder cannot show** | Cream panel, 2px ink outline, 16px corners, print-stamp shadow, full-row mango hover, blank reserved rows, or the pale-mango footer. Custom `NSMenuItem.view` chrome does not survive into Finder’s menu. |
| **Host app** | The stamped cream panel (`FilekitStampPanel`) with Tess’s pixels. Copy Path is the only live row; three blank rows wait for Jack. Hover Copy Path for full-row mango + ink text. Footer is pale mango + one detached leaf, no outline. Clicking Copy Path in the host copies this app’s path so you can check pasteboard wiring; Finder still copies the selected items. |

Blank reserved rows are host-only. Putting empty `NSMenuItem`s in Finder would look like clickable blanks.

If the Copy Path pictogram is missing or goes monochrome, that is Finder flattening `NSMenuItem.image`, not a missing asset.

## What Phase 0 still includes

- A host app (`com.mangostudios.filekit`) so macOS can register the extension
- A Finder Sync extension (`com.mangostudios.filekit.FinderSync`)
- Absolute POSIX path(s) written to `NSPasteboard`; multiple selected items joined with newlines
- Volume monitoring so the item can appear across disks

## Requirements

- A Mac
- Xcode 15 or later (macOS 13 Ventura SDK or newer)
- An Apple ID signed into Xcode so the app and extension can be code-signed (a free Personal Team is enough for local testing)

This repository was scaffolded so it opens on a Mac. It cannot be built on Linux.

## Open, sign, and run

1. Clone this repo and open **`Filekit.xcodeproj`** in Xcode (double-click it, or File → Open).
2. Select the **Filekit** scheme (it builds the host app and embeds the Finder Sync extension).
3. Select a connected Mac as the run destination.
4. For **both** targets (**Filekit** and **FinderSync**), open Signing & Capabilities:
   - Enable **Automatically manage signing**
   - Choose your **Team**
   - Leave bundle IDs as `com.mangostudios.filekit` and `com.mangostudios.filekit.FinderSync` unless those IDs are already taken on your team
5. Product → Run (⌘R). The Filekit window should appear — cream paper, stamp panel, mango footer. Running the host once registers the `.appex` with macOS.

## Enable the Finder extension

Finder Sync extensions stay off until you enable them.

**macOS 15.2 Sequoia and later**

1. System Settings → **General** → **Login Items & Extensions**
2. Find **File Providers** (you may need the info button ⓘ)
3. Turn on **Filekit**

**macOS 13–14 (Ventura / Sonoma)**

1. System Settings → **Privacy & Security** → **Extensions**
2. Open **Added Extensions**
3. Enable **Filekit**

**If the toggle is missing (early macOS 15.0–15.1)**

```sh
pluginkit -e use -i com.mangostudios.filekit.FinderSync
killall Finder
```

The host app’s **Open System Settings** button jumps to Login Items & Extensions when that URL is available.

After enabling, you can quit Filekit. Finder loads the extension itself.

## Test Copy Path (Phase 1.1)

1. Open Finder and select one file.
2. Right-click (or Control-click) the selection.
3. Open **Filekit ›**, then choose **Copy Path**. Finder shows only this real row. The host panel also reserves blank rows for later actions.
4. Paste into TextEdit, Notes, or Terminal. You should see the file’s absolute path, for example `/Users/you/Desktop/report.pdf`.
5. Select two or more files, Copy Path again, and paste. Each path should be on its own line.

Phase 0 success criteria still hold: the paths are correct. Phase 1.1 adds the **Filekit ›** parent and the branded host panel.

## Troubleshooting

**The menu item does not appear**

- Confirm the extension is enabled (steps above).
- Confirm you selected items inside a folder (right-click the files, not only empty window chrome).
- Restart Finder: `killall Finder`
- List registered Finder Sync extensions:

  ```sh
  pluginkit -m -v -p com.apple.FinderSync
  ```

  You should see `com.mangostudios.filekit.FinderSync`.
- If you rebuilt after changing signing or bundle IDs, disable then re-enable the extension, or run:

  ```sh
  pluginkit -e use -i com.mangostudios.filekit.FinderSync
  killall Finder
  ```
- Avoid leaving old copies of Filekit.app around (DerivedData vs `/Applications`). One signed copy at a time is easiest.

**I still see a flat Copy Path with no Filekit › parent**

- You are running the Phase 0 build. This branch embeds the submenu in `FilekitFinderMenu`. Rebuild the **Filekit** scheme, then disable and re-enable the extension.

**Signing errors in Xcode**

- Both targets must use the same Team.
- The extension bundle ID must stay a child of the host ID (`com.mangostudios.filekit.*`).

**Confirm the extension process launched**

In Console.app, filter for `Filekit Finder Sync loaded from`. That log is printed when the extension starts.

## Project layout

```
Filekit.xcodeproj          Xcode project (open this)
Filekit/                   Host app (registers the extension + cream stamp preview)
FinderSync/                Finder Sync extension (Filekit › / Copy Path)
Shared/                    Brand tokens, Copy Path string, mango mark, menu factory
scripts/                   Static Phase 1.1 checks (`python3 scripts/verify_phase_1_1.py`)
```

Bundle IDs:

| Target | Bundle ID |
| --- | --- |
| Filekit (host) | `com.mangostudios.filekit` |
| FinderSync | `com.mangostudios.filekit.FinderSync` |

## Why Finder Sync

Apple still documents [Finder Sync](https://developer.apple.com/documentation/findersync/fifindersync) (`FIFinderSync`) as the way to add contextual menu items for selected Finder items. macOS Services and Quick Actions exist, but they land under Services / Quick Actions rather than as a plain right-click item. Filekit uses Finder Sync and monitors mounted volumes so the item can appear across disks (Finder Sync does not cross volume boundaries unless each volume is registered).
