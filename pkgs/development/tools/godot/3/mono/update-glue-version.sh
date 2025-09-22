#! /usr/bin/env nix-shell
#! nix-shell -i bash -p steam-run unzip wget

# This script updates the hard-coded glue_version in:
#
#    patches/gen_cs_glue_version.py/hardcodeGlueVersionFor{version}.patch
#
# It does so by pulling it from the official build.

set -e

[ -z "$1" ] && echo "Godot version not specified. Exiting." && exit 1

gdversion=$1

# Download and extract the official stable 64-bit X11 mono build of Godot.
gddir="$(mktemp -d)"
trap 'rm -rf -- "$gddir"' EXIT
wget -P "$gddir" https://downloads.tuxfamily.org/godotengine/$gdversion/mono/Godot_v$gdversion-stable_mono_x11_64.zip
unzip "$gddir"/Godot_v$gdversion-stable_mono_x11_64.zip -d "$gddir"

# Generate the mono glue from the official build.
gluedir="$(mktemp -d)"
trap 'rm -rf -- "$gluedir"' EXIT
steam-run "$gddir"/Godot_v$gdversion-stable_mono_x11_64/Godot_v$gdversion-stable_mono_x11.64 --generate-mono-glue "$gluedir"

# Extract the glue version.
glueversion=$(grep -Po '(?<=get_cs_glue_version\(\) \{ return )[0-9]+(?=; \})' "$gluedir"/mono_glue.gen.cpp)

patchdir=./patches/gen_cs_glue_version.py/
patchprefix=hardcodeGlueVersion_
newpatchname=$patchprefix$gdversion.patch

# Update the patch with the obtained glue version.
sed -i "s/^+    glue_version = [0-9]\+$/+    glue_version = $glueversion/" $patchdir/$patchprefix*.patch

mv $patchdir/$patchprefix*.patch $patchdir/$patchprefix$gdversion.patch

echo "Updated $patchdir/$patchprefix$gdversion.patch with glue_version: $glueversion"
