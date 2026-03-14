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
  pname = "libbacktrace";
in
bash.runCommand "${pname}-${common.version}"
  {
    inherit (common) meta version;
    inherit pname;

    nativeBuildInputs = [
      gcc
      binutils
      gnumake
      gnused
      gnugrep
      gawk
      diffutils
      findutils
    ];
  }
  ''
    # Unpack
    pushd ${common.monorepoSrc}

    mkdir -p "$out/gcc"
    cp gcc/BASE-VER gcc/DATESTAMP "$out/gcc"
    cp -r include libbacktrace "$out"
    cp config.guess config.rpath config.sub config-ml.in \
       ltmain.sh install-sh move-if-change mkinstalldirs \
       test-driver "$out"
    [[ -f MD5SUMS ]]; cp MD5SUMS "$out"

    popd

    ${common.monorepoSrc}/libbacktrace/configure --prefix="$out" \
      --build=${buildPlatform.config} \
      --host=${hostPlatform.config}

    # Build
    make -j $NIX_BUILD_CORES

    # Install
    mkdir -p "$out/lib/"
    mkdir -p "$out/include/"
    cp .libs/*.a "$out/lib/"
    cp libbacktrace*.la "$out/lib"

    chmod +w "$out/include"
    cp backtrace-supported.h "$out/include/"
  ''
