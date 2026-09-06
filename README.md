# Filekit

Filekit is a native macOS Finder utility from Mango Studios. Phase 0 proves one thing: a Finder right-click item that copies the selected file path(s) to the clipboard.

This is not a design pass. There is one menu item, **Copy Path**, and no extra Finder UI.

## What Phase 0 includes

- A minimal host app (`com.mangostudios.filekit`) so macOS can register the extension
- A Finder Sync extension (`com.mangostudios.filekit.FinderSync`) — Apple’s current API for Finder contextual menu items (`FIFinderSync`)
- One right-click action: **Copy Path**
- Absolute POSIX path(s) written to `NSPasteboard`; multiple selected items are joined with newlines

## Requirements

- A Mac
- Xcode 15 or later (macOS 13 Ventura SDK or newer)
- An Apple ID signed into Xcode so the app and extension can be code-signed (a free Personal Team is enough for local testing)

This repository was scaffolded so it opens on a Mac. It cannot be built on Linux.

## Open, sign, and run

1. Clone this repo and open **`Filekit.xcodeproj`** in Xcode (double-click it, or File → Open).
2. Select the **Filekit** scheme (it builds the host app and embeds the Finder Sync extension).
3. Select a connected Mac as the run destination.
4. For **both** targets (**Filekit** and **FilekitFinderSync**), open Signing & Capabilities:
   - Enable **Automatically manage signing**
   - Choose your **Team**
   - Leave bundle IDs as `com.mangostudios.filekit` and `com.mangostudios.filekit.FinderSync` unless those IDs are already taken on your team
5. Product → Run (⌘R). The Filekit window should appear. Running the host once registers the `.appex` with macOS.

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

## Test Copy Path (Phase 0 pass)

1. Open Finder and select one file.
2. Right-click (or Control-click) the selection.
3. Choose **Copy Path**. It should appear as a normal Finder menu item, not a branded submenu.
4. Paste into TextEdit, Notes, or Terminal. You should see the file’s absolute path, for example `/Users/you/Desktop/report.pdf`.
5. Select two or more files, Copy Path again, and paste. Each path should be on its own line.

That is the Phase 0 success criteria.

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

**Signing errors in Xcode**

- Both targets must use the same Team.
- The extension bundle ID must stay a child of the host ID (`com.mangostudios.filekit.*`).

**Confirm the extension process launched**

In Console.app, filter for `Filekit Finder Sync loaded from`. That log is printed when the extension starts.

## Project layout

```
Filekit.xcodeproj          Xcode project (open this)
Filekit/                   Host app (registers the extension)
FilekitFinderSync/         Finder Sync extension (Copy Path)
```

Bundle IDs:

| Target | Bundle ID |
| --- | --- |
| Filekit (host) | `com.mangostudios.filekit` |
| FilekitFinderSync | `com.mangostudios.filekit.FinderSync` |

The extension target and product/module are named **FilekitFinderSync** so they do not collide with Apple’s `FinderSync` framework (`import FinderSync` / `FIFinderSync`).

## Why Finder Sync

Apple still documents [Finder Sync](https://developer.apple.com/documentation/findersync/fifindersync) (`FIFinderSync`) as the way to add contextual menu items for selected Finder items. macOS Services and Quick Actions exist, but they land under Services / Quick Actions rather than as a plain right-click item. Phase 0 uses Finder Sync and monitors mounted volumes so the item can appear across disks (Finder Sync does not cross volume boundaries unless each volume is registered).
