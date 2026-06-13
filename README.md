# Speech-To-Text

Minimalist **push-to-talk** dictation for **Hyprland**: hold a hotkey to talk, release to drop the transcribed text into your clipboard.

A small bash script pipes your mic to a local [Speaches](https://speaches.ai) (Whisper) server — fully offline, language auto-picked from your keyboard layout.

## Setup

Run from a terminal:

```sh
curl -fsSL https://raw.githubusercontent.com/SubZtep/stt/v0.0.1/setup.sh | bash
```

Automatic installation steps:

1. Check dependencies (`docker`, `ffmpeg`, `wl-clipboard`, `libnotify`, `jq`, `hyprland`).\
   _On Arch/Omarchy it offers to install missing ones via pacman._
2. Download the scripts into user binaries.
3. Start the Speaches server.
4. Download the Whisper model.
5. Add the Hyprland keybinding (`SUPER` + `` ` ``).

Re-running is safe. Linux/Hyprland only.

> The first transcription after install can be slow while the model loads; it's fast after that.

## Uninstall

```sh
curl -fsSL https://raw.githubusercontent.com/SubZtep/stt/v0.0.1/setup.sh | bash -s -- --uninstall
```

Removes the scripts, the keybinding, the server, and the downloaded models.
