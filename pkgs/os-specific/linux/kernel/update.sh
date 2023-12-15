#!/usr/bin/env bash
cd "$(dirname "$(readlink -f "$0")")" || exit

echo "Update linux (mainline)"
COMMIT=1 ./update-mainline.py || echo "update-mainline failed with exit code $?"

echo "Update linux-rt"
COMMIT=1 ./update-rt.sh || echo "update-rt failed with exit code $?"

echo "Update linux-libre"
COMMIT=1 ./update-libre.sh || echo "update-libre failed with exit code $?"

echo "Update linux-hardened"
COMMIT=1 ./hardened/update.py || echo "update-hardened failed with exit code $?"
