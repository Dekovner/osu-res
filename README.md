# osu-res

> **Universal Custom Resolution Manager for osu! (Wine on Linux)**  
> Inject arbitrary custom stretched resolutions (4:3, 5:4, 1:1, 16:10) directly into the in-game resolution dropdown menu without Gamescope, blur, or latency.

---

##  Features

- **In-Game Dropdown Integration**: Custom resolutions appear directly in the **Options → Graphics → Screen Resolution** dropdown list inside osu!.
- **On-the-Fly Switching**: Change resolutions live in-game without editing config files or restarting the client.
- **Zero Blur / Native Quality**: No Gamescope linear scaling, no pixelation artifacts, and no extra overhead. Renders directly via your GPU driver at your monitor's native refresh rate (144Hz, 180Hz, 240Hz, 360Hz).
- **100% Safe (0% Ban Risk)**: `osu!.exe` and its assemblies are completely untouched. Anti-cheat (Bancho) sees standard Windows display modes returned by User32.
- **Universal & Version-Independent**: Dynamic signature scanner finds Wine's display mode table in `win32u.so` across Wine versions (Wine 8, 9, 10, 11, Proton, CachyOS, Lutris).
- **Persistent Across Updates**: Integrates seamlessly with `osu-winello` launch hooks, so Wine updates will never wipe your modes.
- **Interactive TUI & CLI**: Use the interactive menu or scriptable command-line flags.

---

## 🚀 Quick Start / Installation

### 1. Download & Install
```bash
git clone https://github.com/Dekovner/osu-res.git
cd osu-res
chmod +x osu-res install.sh
./install.sh
```

Or manually copy `osu-res` to your `~/.local/bin/`:
```bash
cp osu-res ~/.local/bin/osu-res
chmod +x ~/.local/bin/osu-res
```

Make sure `~/.local/bin` is in your `$PATH`.

---

## 🎮 How to Use

### Interactive Mode
Simply run `osu-res` without arguments:
```bash
osu-res
```
```text
====================================================
       osu-res: Custom Resolution Tool for Wine     
====================================================

Select an option:
  1) List custom resolutions
  2) Add custom resolution (Width x Height)
  3) Remove resolution
  4) Apply all resolutions now
  5) Restore Wine to stock backup
  0) Exit

Your choice [0-5]: 
```

### Command-Line Interface (CLI)

* **Add a custom resolution:**
  ```bash
  osu-res add 1350 1080 -d "5:4 Full HD Stretched"
  osu-res add 1440 1080 -d "4:3 Full HD Stretched"
  osu-res add 1100 720  -d "1100x720 Stretched"
  ```

* **List configured resolutions & detected display:**
  ```bash
  osu-res list
  ```

* **Remove a resolution:**
  ```bash
  osu-res remove 1350 1080
  ```

* **Apply all resolutions (auto-hook):**
  ```bash
  osu-res apply
  ```

* **Restore Wine to stock backup:**
  ```bash
  osu-res restore
  ```

---

## ⚙️ How It Works Under the Hood

1. **The Root Problem**: In osu!stable under Wine on Linux, the resolution dropdown enumerates display modes using the Win32 `EnumDisplaySettings` API, which forwards calls to Wine's `win32u.so` kernel dispatcher. Wine uses a static table of fallback resolutions and filters out anything larger than the current monitor's dimensions. Common custom competitive modes (like `1440x1080`, `1350x1080`, `1100x720`) are missing from this table, preventing osu! from offering them in the menu.
2. **The Solution**: `osu-res` uses pattern matching to locate Wine's static mode table in `win32u.so`. It safely swaps unused display mode slots with your desired custom resolutions and simultaneously registers CVT modelines in XRandR / Xwayland for your primary display.
3. **The Result**: Wine exposes your custom resolutions to OpenTK and osu!, letting you select them natively in fullscreen with full GPU hardware scaling.

---

## 🔄 Automatic Launcher Hook (osu-winello)

To ensure your custom resolutions are automatically available every time you start osu! (even after reboots or Wine updates), create `~/.local/share/osuconfig/configs/custom_resolutions.cfg`:

```bash
osu-res apply >/dev/null 2>&1
```

`osu-wine` loads all `*.cfg` files before launching the game, keeping your custom resolutions always active.

---

## 🛡️ Bancho Safety

`osu-res` modifies only Wine's internal Linux display table (`win32u.so`) in your user directory. It does **not** touch `osu!.exe`, memory offsets, or game assemblies. As far as osu! and Bancho are concerned, your display adapter natively advertises these resolutions.

---

## 📄 License

MIT License. Feel free to modify, share, and contribute!
