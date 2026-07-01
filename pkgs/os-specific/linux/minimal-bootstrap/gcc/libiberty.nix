{
  lib,
  buildPlatform,
  hostPlatform,
  fetchurl,
  bash,
  coreutils,
  gcc,
  binutils,
  gnumake,
  gnused,
  gnugrep,
  gawk,
  diffutils,
  findutils,
  gnutar,
  gzip,
  bzip2,
  xz,
}:
let
  common = import ./common.nix {
    inherit
      lib
      bash
      fetchurl
      gnutar
      xz
      ;
  };
  pname = "libiberty";

  binutilsTargetPrefix = lib.optionalString (
    hostPlatform.config != buildPlatform.config
  ) "${hostPlatform.config}-";
in
bash.runCommand "${pname}-${common.version}"
  {
    inherit pname;
    inherit (common) version meta;

    nativeBuildInputs = [
      gcc
      binutils
      gnumake
      gnused
      gnugrep
      gawk
      diffutils
      findutils
      gnutar
      gzip
      bzip2
      xz
    ];
  }
  ''
    # Unpack
    pushd ${common.monorepoSrc}

    mkdir -p "$out/gcc"
    cp gcc/BASE-VER gcc/DATESTAMP "$out/gcc"
    cp -r include libiberty "$out"
    cp config.guess config.rpath config.sub config-ml.in \
       ltmain.sh install-sh mkinstalldirs "$out"
    [[ -f MD5SUMS ]]; cp MD5SUMS "$out"

    popd

    ${common.monorepoSrc}/libiberty/configure \
      --build=${buildPlatform.config} \
      --host=${hostPlatform.config} \
      --prefix="$out" \
      --enable-install-libiberty \
      enable_host_pie=yes

    # Build
    make -j $NIX_BUILD_CORES

    chmod -R +w "$out/include"

    # Install
    make -j $NIX_BUILD_CORES install-strip

    # We absolutely want a PIC, otherwise the build breaks
    cp pic/libiberty.a $out/lib/libiberty.a
    cp pic/libiberty.a $out/lib/libiberty_pic.a
    if [ -d "$out/lib64" ]; then
      shopt -s dotglob
      for lib in $out/lib64/*; do
        mv --no-clobber "$lib" "$out/lib/"
      done
      shopt -u dotglob
      rm -rf "$out/lib64"
      ln -s lib "$out/lib64"
    fi
    find $out/lib -type f -exec ${binutilsTargetPrefix}strip --strip-debug {} + || true
  ''
