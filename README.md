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
  3) Remove a resolution
  4) Clear all custom resolutions
  5) Apply all resolutions now
  6) Restore Wine to stock backup
  7) Install / Remove auto-apply launch hook
  0) Exit

Your choice [0-7]: 
```

### Command-Line Interface (CLI)

* **Add a custom resolution:**
  ```bash
  osu-res add 1350 1080 -d "5:4 Full HD Stretched"
  osu-res add 1440 1080 -d "4:3 Full HD Stretched"
  osu-res add 1100 768  -d "1100x768 Stretched"
  ```

* **List configured resolutions & detected display:**
  ```bash
  osu-res list
  ```

* **Remove a resolution:**
  ```bash
  osu-res remove 1350 1080
  ```

* **Clear all custom resolutions:**
  ```bash
  osu-res clear
  ```

* **Apply all resolutions (auto-sync):**
  ```bash
  osu-res apply
  ```

* **Manage osu-winello launch hook:**
  ```bash
  osu-res hook status
  osu-res hook install
  osu-res hook remove
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

## 🔄 Why the Launcher Hook is Needed (osu-winello)

When you run `osu-res add <w> <h>`, two things happen under the hood:
1. **On disk:** It patches Wine's `win32u.so` static resolution table (this persists on disk).
2. **In memory:** It registers a high-refresh-rate CVT modeline in your running **XRandR / Xwayland** display session.

Because of this, **your custom resolutions work immediately** inside osu! right after adding them—no reboot or hook required for your current session!

### So why is the hook needed?

* **Display Server Volatility (After Reboots):**  
  XRandR / Xwayland keeps dynamic modelines in volatile memory. Whenever you reboot your computer or log out of your desktop session, XRandR resets back to factory defaults.  
  Without the hook, after a reboot your game may either fail to switch to the custom mode or fall back to 60Hz instead of your monitor's native high refresh rate (144Hz/180Hz/240Hz+), unless you manually run `osu-res apply` in a terminal every time.

* **Wine Updates:**  
  Whenever `osu-winello` (or your runner manager) updates Wine, it downloads a fresh `win32u.so`, overwriting previous patches.

### The Solution: "Set and Forget" Auto-Hook

The launch hook is a tiny non-blocking one-liner (`osu-res apply >/dev/null 2>&1`) placed inside `~/.local/share/osuconfig/configs/custom_resolutions.cfg`.

Before `osu!.exe` boots up, `osu-wine` sources this config and executes `osu-res apply` in a fraction of a second:
- Restores all your configured custom resolutions and refresh rates into XRandR automatically.
- Automatically re-patches `win32u.so` if Wine was updated.
- Completely seamless: you never need to touch the terminal again after setting up your resolutions.

### How to Install the Hook:
* **Interactive:** `osu-res` will automatically detect `osu-winello` and offer to install the hook on launch. You can also toggle it anytime via menu option **`7`**.
* **CLI:**
  ```bash
  osu-res hook install    # Install the launch hook
  osu-res hook status     # Check if the hook is active
  osu-res hook remove     # Remove the hook
  ```

---

## 🛡️ Bancho Safety

`osu-res` modifies only Wine's internal Linux display table (`win32u.so`) in your user directory. It does **not** touch `osu!.exe`, memory offsets, or game assemblies. As far as osu! and Bancho are concerned, your display adapter natively advertises these resolutions.

---

## 📄 License

MIT License. Feel free to modify, share, and contribute!
