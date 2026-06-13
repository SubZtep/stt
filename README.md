# Speech-To-Text

A minimalist **push-to-talk** dictation workflow after full setup: hold a hotkey to talk, release to drop the transcribed text directly into your clipboard.

This lightweight bash script pipes your microphone to a local Speaches (Whisper) server. It operates entirely offline using only ffmpeg and curl, with automatic language selection based on your current keyboard layout.

## Setup

By default, it's running on the CPU with multi-language model. 

### Run Speaches server

```sh
docker run -d \
  --name speaches \
  -p 8000:8000 \
  -e ENABLE_UI=False \
  -v hf-hub-cache:/home/ubuntu/.cache/huggingface/hub \
  ghcr.io/speaches-ai/speaches:latest-cpu \
/
```

<!-- -e 'PRELOAD_MODELS=["Systran/faster-whisper-small"]' \ -->

### Download model

```sh
curl -X POST http://localhost:8000/v1/models/Systran/faster-whisper-small
```

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/SubZtep/stt/main/install.sh | bash
```

It downloads `stt` + `stt-layout-lang` into `~/.local/bin` . Override the location
with `PREFIX=/usr/local` . Requires ffmpeg + curl; the keybinding also uses
wl-clipboard + libnotify, and the layout helper uses jq + hyprctl.

<!-- (Prefer git? `git clone https://github.com/SubZtep/stt.git` then `install -m755 stt stt-layout-lang ~/.local/bin/` .) -->

## Test

The script:
1. Records the mic until stopped (Ctrl+C / SIGINT), transcribes via a local [Speaches](https://speaches.ai) server.
2. Prints the transcript to stdout (exit 0) or an error to stderr (exit 1).

```sh
stt            # speak, press Ctrl-C once to stop -> prints transcript
```

> Clipboard, notifications, and language-from-layout live in the keybinding — `stt` itself stays portable (only ffmpeg + curl).

## Hyprland push-to-talk

`~/.config/hypr/bindings.conf` — hold to talk, release to transcribe. Language
is chosen from the active keyboard layout via `stt-layout-lang` :

```conf
bind  = SUPER, grave, exec, out=$(STT_LANGUAGE=$(stt-layout-lang) stt 2>/tmp/stt.err) && wl-copy -- "$out" && notify-send "stt" "$out" || notify-send "stt error" "$(cat /tmp/stt.err)"
bindr = SUPER, grave, exec, pkill -INT ffmpeg
```

Then `hyprctl reload` .

* press → `stt` records; stdout captured by `$(...)`
* release → `pkill -INT ffmpeg` finalizes the recording;  `stt` (which ignores
  the signal itself) transcribes and prints
* exit 0 → clipboard + notification with the text
* exit 1 → notification with the error text

To pin a fixed language instead, drop the helper: `STT_LANGUAGE=hu stt ...` .
To let Whisper auto-detect from the audio, omit `STT_LANGUAGE` entirely — often
more reliable than layout if you don't switch layout with your spoken language.

## stt-layout-lang

Maps the active Hyprland layout ( `hyprctl devices` → `active_keymap` ) to a
Whisper code. Edit the `case` block for your layouts. It's deliberately separate
so `stt` has no Hyprland/jq dependency — a Sway/X11 user swaps in their own.

## Env

| var          | default                                  |
|--------------|------------------------------------------|
| STT_URL      | http://localhost:8000/v1                 |
| STT_MODEL    | Systran/faster-whisper-small             |
| STT_LANGUAGE | (auto-detect) — ISO-639-1 like `en` , `hu` (not `US` / `GB` ) |
| STT_DEVICE   | ffmpeg input (mac `:0` , linux `default` ) |

## Uninstall

```sh
rm -f ~/.local/bin/stt ~/.local/bin/stt-layout-lang
```

Then remove the `bind` / `bindr` lines from `~/.config/hypr/bindings.conf` and
`hyprctl reload` . The speaches container is separate:
`docker rm -f speaches` (add `docker volume rm hf-hub-cache` to drop models).
