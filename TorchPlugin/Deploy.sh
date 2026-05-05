#!/usr/bin/env sh
set -eu

if [ "$#" -lt 4 ]; then
    echo "ERROR: Missing required parameters" >&2
    exit 1
fi

ASSEMBLY_FILENAME=$1
SOURCE=${2%/}
TORCH=${3%/}
PLUGIN_NAME=${4%/}
PLUGIN_DIR="$TORCH/Plugins/$PLUGIN_NAME"

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

copy_file "$ASSEMBLY_FILENAME"
copy_file "manifest.xml"
copy_file "0Harmony.dll"
