#!/usr/bin/env sh
set -eu

# Linux/macOS equivalent of Deploy.bat for the server plugin.
# Copies the built plugin DLL into the Magnetar "Local" plugin folder.
# On Linux Magnetar stores its data under ~/.config/Magnetar (no "Legacy" subfolder).
# Usage: Deploy.sh <NAME> <SOURCE>
#   NAME   - plugin DLL file name (e.g. MyPlugin.dll)
#   SOURCE - directory containing the built DLL

if [ "$#" -lt 2 ]; then
    echo "ERROR: Missing required parameters" >&2
    exit 1
fi

NAME=$1
SOURCE=${2%/}

# Resolve the source file: prefer "SOURCE/NAME", fall back to SOURCE itself.
SRCFILE="$SOURCE/$NAME"
if [ ! -f "$SRCFILE" ]; then
    if [ -f "$SOURCE" ]; then
        SRCFILE=$SOURCE
    else
        echo "ERROR: Source not found: $SOURCE or $SOURCE/$NAME" >&2
        exit 1
    fi
fi

find_plugin_dir() {
    if [ -n "${MAGNETAR_LOCAL_DIR:-}" ]; then
        printf '%s\n' "$MAGNETAR_LOCAL_DIR"
        return 0
    fi

    for root in "${MAGNETAR_DIR:-}" "$HOME/.config/Magnetar" "$HOME/.local/share/Magnetar"; do
        if [ -z "$root" ]; then
            continue
        fi

        for candidate in "$root/Local" "$root/Legacy/Local"; do
            if [ -d "$candidate" ]; then
                printf '%s\n' "$candidate"
                return 0
            fi
        done

        if [ -d "$root" ]; then
            printf '%s\n' "$root/Local"
            return 0
        fi
    done

    return 1
}

if ! PLUGIN_DIR=$(find_plugin_dir); then
    echo "Missing Magnetar folder. Set MAGNETAR_LOCAL_DIR to your Magnetar Local plugin folder." >&2
    exit 2
fi

mkdir -p "$PLUGIN_DIR"

# Copy the plugin, retrying in case the file is temporarily locked by a running server.
echo "Copying \"$SRCFILE\" to \"$PLUGIN_DIR/\""
i=1
while [ "$i" -le 10 ]; do
    if cp -f "$SRCFILE" "$PLUGIN_DIR/"; then
        exit 0
    fi
    sleep 1
    i=$((i + 1))
done

echo "ERROR: Could not copy \"$NAME\"." >&2
exit 1
