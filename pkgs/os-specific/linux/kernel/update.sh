#!/usr/bin/env bash
cd "$(dirname "$(readlink -f "$0")")" || exit

echo "Update linux (mainline)"
COMMIT=1 ./update-mainline.py || echo "update-mainline failed with exit code $?"
