################################################################################
# Build all of the platforms manually since the `all_platforms' target
# doesn't preserve all of the build outputs and overrides CFLAGS.
set -e
set -u

################################################################################
# Prevent a warning from shellcheck:
out=${out:-/tmp}

################################################################################
export CFLAGS=$NIX_CFLAGS_COMPILE

################################################################################
PRODUCTS="blackmagic.bin blackmagic.hex blackmagic_dfu.bin blackmagic_dfu.hex"

################################################################################
make_platform() {
  echo "Building for hardware platform $1"

  make clean
  make PROBE_HOST="$1"

  if [ "$1" = libftdi ]; then
    mkdir -p "$out/bin"
    install -m 0555 blackmagic "$out/bin"
  fi

  for f in $PRODUCTS; do
    if [ -r "$f" ]; then
      mkdir -p "$out/firmware/$1"
      install -m 0444 "$f" "$out/firmware/$1"
    fi
  done

}

################################################################################
# Start by building libopencm3:
make -C libopencm3

################################################################################
# And now all of the platforms:
cd src

for platform in platforms/*/Makefile.inc; do
  probe=$(basename "$(dirname "$platform")")
  make_platform "$probe"
done
