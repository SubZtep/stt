# Speech-To-Text

Minimalist **push-to-talk** dictation for **Hyprland**: hold a hotkey to talk, release to drop the transcribed text into your clipboard.

A small bash script pipes your mic to a local [Speaches](https://speaches.ai) (Whisper) server — fully offline, language auto-picked from your keyboard layout.

## Setup

Run from a terminal:

```sh
curl -fsSL https://raw.githubusercontent.com/SubZtep/stt/v0.2.0/setup.sh | bash
```

Automatic installation steps:

1. Check dependencies (`docker`, `ffmpeg`, `wl-clipboard`, `libnotify`, `jq`, `hyprland`).\
   _On Arch/Omarchy it offers to install missing ones via pacman._
2. Create `~/.config/stt.json` from the default configuration (if not already present), including only the languages configured in the keyboard layout.
3. Download the scripts into user binaries.
4. Start the Speaches server and download the configured models.
5. Add the Hyprland keybinding (`SUPER` + `` ` ``).

Re-running is safe. Linux/Hyprland only.

> The first transcription after install can be slow while the model loads; it's fast after that.

## Configuration

`~/.config/stt.json` is generated on first install using the [default configuration](./config/default.json). Use it as a starting point and customise it to suit your workflow.

**`models`** maps ISO 639-1 language codes to Hugging Face model IDs. The active keyboard layout (detected via `hyprctl`) automatically selects the right model — no extra config needed. Re-run setup after adding a language to download its model.

## Uninstall

```sh
curl -fsSL https://raw.githubusercontent.com/SubZtep/stt/v0.2.0/setup.sh | bash -s -- --uninstall
```

Removes the scripts, the config, the keybinding, the server, and the downloaded models.
