#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash coreutils gnutar jq

# Generate a sources.json for a version of GNU mes. Creates lists of source files
# from build-aux/configure-lib.sh.
#
# You may point this tool at a manually downloaded tarball, but more ideal is
# using the source tarball from Nixpkgs. For example:
#
# MES_TARBALL="$(nix-build --no-link -A minimal-bootstrap.mes.src ../../../../..)"
# ./gen-sources.sh "$MES_TARBALL" > ./new-sources.json

set -eu

# Supported platforms
ARCHS="x86 x86_64"
KERNELS="linux"
COMPILERS="mescc gcc"


to_json_array() {
  if [ $# -eq 0 ]; then
    echo '[]'
  else
    printf '%s\n' "$@" | jq --raw-input --null-input '[inputs]'
  fi
}

gen_sources() {
  # Configuration variables used by configure-lib.sh
  export mes_libc=mes
  export mes_cpu=$1
  export mes_kernel=$2
  export compiler=$3

  # Populate source file lists
  source $CONFIGURE_LIB_SH

  jq --null-input \
    --arg key "$mes_cpu.$mes_kernel.$compiler" \
    --argjson libc_mini_SOURCES "$(to_json_array $libc_mini_SOURCES)" \
    --argjson libmescc_SOURCES "$(to_json_array $libmescc_SOURCES)" \
    --argjson libtcc1_SOURCES "$(to_json_array $libtcc1_SOURCES)" \
    --argjson libc_SOURCES "$(to_json_array $libc_SOURCES)" \
    --argjson libc_tcc_SOURCES "$(to_json_array $libc_tcc_SOURCES)" \
    --argjson libc_gnu_SOURCES "$(to_json_array $libc_gnu_SOURCES)" \
    --argjson mes_SOURCES "$(to_json_array $mes_SOURCES)" \
    '{($key): {
      libc_mini_SOURCES: $libc_mini_SOURCES,
      libmescc_SOURCES: $libmescc_SOURCES,
      libtcc1_SOURCES: $libtcc1_SOURCES,
      libc_SOURCES: $libc_SOURCES,
      libc_tcc_SOURCES: $libc_tcc_SOURCES,
      libc_gnu_SOURCES: $libc_gnu_SOURCES,
      mes_SOURCES: $mes_SOURCES
    }}'
}


MES_TARBALL=$1
if [ ! -f $MES_TARBALL ]; then
    echo "Provide path to mes-x.x.x.tar.gz as first argument" >&2
    exit 1
fi
echo "Generating sources.json from $MES_TARBALL" >&2

TMP=$(mktemp -d)
cd $TMP
echo "Workdir: $TMP" >&2

echo "Extracting $MES_TARBALL" >&2
tar --strip-components 1 -xf $MES_TARBALL

CONFIGURE_LIB_SH="$TMP/build-aux/configure-lib.sh"
if [ ! -f $CONFIGURE_LIB_SH ]; then
    echo "Could not find mes's configure-lib.sh script at $CONFIGURE_LIB_SH" >&2
    exit 1
fi

# Create dummy config expected by configure-lib.sh
touch config.sh
chmod +x config.sh


echo "Configuring with $CONFIGURE_LIB_SH" >&2

RESULT='{}'
for arch in $ARCHS; do
  for kernel in $KERNELS; do
    for compiler in $COMPILERS; do
      PART=$(gen_sources $arch $kernel $compiler)
      RESULT=$(jq --null-input --argjson a "$RESULT" --argjson b "$PART" '$a * $b')
    done
  done
done

echo "$RESULT" | jq --sort-keys .
