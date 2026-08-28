#! /usr/bin/env nix-shell
#! nix-shell -i bash -p unzip wget godot3.patch-godot-bin -I nixpkgs=.
# shellcheck shell=bash

# This script updates the hard-coded glue_version in:
#
#    patches/gen_cs_glue_version.py/hardcodeGlueVersionFor{version}.patch
#
# It does so by pulling it from the official build.

set -e

if [[ -z "$1" ]]; then
  gdversion=$(nix-instantiate --eval --raw -A ${UPDATE_NIX_ATTR_PATH:-godot3}.version)
else
  gdversion=$1
fi

# Download and extract the official stable 64-bit X11 mono build of Godot.
tmpdir="$(mktemp -d)"
trap 'rm -rf -- "$tmpdir"' EXIT
gddir="$tmpdir"/gd
gluedir="$tmpdir"/glue
mkdir -p "$gddir" "$gluedir"

wget -O "$gddir"/Godot_v$gdversion-stable_mono_x11_64.zip "https://downloads.godotengine.org/?version=$gdversion&flavor=stable&slug=mono_x11_64.zip&platform=linux.64"
unzip "$gddir"/Godot_v$gdversion-stable_mono_x11_64.zip -d "$gddir"

# Generate the mono glue from the official build.
patch-godot-bin "$gddir"/Godot_v$gdversion-stable_mono_x11_64/Godot_v$gdversion-stable_mono_x11.64
"$gddir"/Godot_v$gdversion-stable_mono_x11_64/Godot_v$gdversion-stable_mono_x11.64 --generate-mono-glue "$gluedir"

# Extract the glue version.
glueversion=$(grep -Po '(?<=get_cs_glue_version\(\) \{ return )[0-9]+(?=; \})' "$gluedir"/mono_glue.gen.cpp)

patchdir="$(dirname "${BASH_SOURCE[0]}")"/patches/gen_cs_glue_version.py/
patchprefix=hardcodeGlueVersion_
newpatchname=$patchprefix$gdversion.patch

# Update the patch with the obtained glue version.
sed -i "s/^+    glue_version = [0-9]\+$/+    glue_version = $glueversion/" $patchdir/$patchprefix*.patch

mv $patchdir/$patchprefix*.patch $patchdir/$patchprefix$gdversion.patch

echo "Updated $patchdir/$patchprefix$gdversion.patch with glue_version: $glueversion"
