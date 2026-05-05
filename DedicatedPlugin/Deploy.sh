#!/usr/bin/env sh
set -eu

if [ "$#" -lt 3 ]; then
    echo "ERROR: Missing required parameters" >&2
    exit 1
fi

NAME=$1
SOURCE=${2%/}
DEDICATED64=${3%/}
PLUGIN_DIR="$DEDICATED64/Plugins"

mkdir -p "$PLUGIN_DIR"

copy_file() {
    file_name=$1
    src="$SOURCE/$file_name"

    if [ ! -f "$src" ]; then
        echo "ERROR: Source not found: $src" >&2
        exit 1
    fi

    echo "Copying \"$file_name\" to \"$PLUGIN_DIR/\""
    cp -f "$src" "$PLUGIN_DIR/"
}

copy_file "$NAME"
copy_file "0Harmony.dll"
