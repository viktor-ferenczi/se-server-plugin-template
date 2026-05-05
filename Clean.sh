#!/usr/bin/env sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

rm -rf \
    "$SCRIPT_DIR/ClientPlugin/bin" "$SCRIPT_DIR/ClientPlugin/obj" \
    "$SCRIPT_DIR/DedicatedPlugin/bin" "$SCRIPT_DIR/DedicatedPlugin/obj" \
    "$SCRIPT_DIR/TorchPlugin/bin" "$SCRIPT_DIR/TorchPlugin/obj"
