source $stdenv/setup

mkdir $out
cd $out
tar zxvf $src

# Make the Nix store available to MSYS.
# Hack: we are assuming that the stdenv is based on Cygwin.

nixdir="$(cygpath --windows /nix)"
mkdir $out/nix
cat > $out/etc/fstab <<EOF
#Win32_Path      Mount_Point
$nixdir          /nix
EOF
