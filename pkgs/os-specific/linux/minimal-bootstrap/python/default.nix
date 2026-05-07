{
  lib,
  buildPlatform,
  hostPlatform,
  fetchurl,
  bash,
  gcc,
  musl,
  binutils,
  gnumake,
  gnupatch,
  gnused,
  gnugrep,
  gawk,
  diffutils,
  findutils,
  gnutar,
  xz,
  zlib,
}:
let
  pname = "python";
  version = "3.14.4";

  src = fetchurl {
    url = "https://www.python.org/ftp/python/${version}/Python-${version}.tar.xz";
    hash = "sha256-2SPFEwPjjiSRNvwb3zVo1W7LAyFO/e9IUWF209f6rvg=";
  };

  patches = [
    # Disable the use of ldconfig in ctypes.util.find_library (since
    # ldconfig doesn't work on NixOS), and don't use
    # ctypes.util.find_library during the loading of the uuid module
    # (since it will do a futile invocation of gcc (!) to find
    # libuuid, slowing down program startup a lot).
    ./no-ldconfig.patch
  ];
in
bash.runCommand "${pname}-${version}"
  {
    inherit pname version;

    nativeBuildInputs = [
      gcc
      musl
      binutils
      gnumake
      gnupatch
      gnused
      gnugrep
      gawk
      diffutils
      findutils
      gnutar
      xz
    ];

    passthru.tests.get-version =
      result:
      bash.runCommand "${pname}-get-version-${version}" { } ''
        ${result}/bin/python3 --version
        mkdir $out
      '';

    meta = {
      description = "A high-level dynamically-typed programming language";
      homepage = "https://www.python.org";
      license = lib.licenses.psfl;
      mainProgram = "python3";
      platforms = lib.platforms.linux;
      teams = [ lib.teams.minimal-bootstrap ];
    };
  }
  ''
    # Unpack
    tar xf ${src}
    cd Python-${version}

    # Patch
    ${lib.concatMapStringsSep "\n" (f: "patch -Np1 -i ${f}") patches}

    # Configure
    export CC=musl-gcc
    export C_INCLUDE_PATH="${zlib}/include"
    export LIBRARY_PATH="${zlib}/lib"
    export LDFLAGS="-Wl,-rpath,${zlib}/lib -L${zlib}/lib"
    export LD_LIBRARY_PATH="$LIBRARY_PATH"
    bash ./configure \
      --prefix=$out \
      --build=${buildPlatform.config} \
      --host=${hostPlatform.config} \
      --disable-test-modules \
      --without-ensurepip \
      --without-static-libpython

    # Build
    make -j $NIX_BUILD_CORES

    # Install
    make -j $NIX_BUILD_CORES install

    # Remove lib-dynload extension modules not needed for glibc's build scripts.
    # glibc uses Python only for scripts that import: os, re, subprocess, argparse,
    # pathlib, collections, tempfile.  Following the import chain:
    #   subprocess -> selectors -> math, select, fcntl, _posixsubprocess
    #   pathlib -> grp
    #   tempfile -> random -> _random, bisect -> _bisect
    # Everything else in lib-dynload is dead weight in the bootstrap context.
    find $out/lib/python*/lib-dynload -name '*.so' \
      ! -name '_bisect*' \
      ! -name '_posixsubprocess*' \
      ! -name '_random*' \
      ! -name 'fcntl*' \
      ! -name 'grp*' \
      ! -name 'math*' \
      ! -name 'select*' \
      -delete

    rm -rf \
      $out/lib/python*/ensurepip \
      $out/lib/python*/idlelib \
      $out/lib/python*/site-packages \
      $out/lib/python*/test \
      $out/lib/python*/tkinter \
      $out/lib/python*/turtledemo \
      $out/share/man

    rm -f $out/bin/idle* $out/bin/pip*
    find $out/lib/python* -type d -name __pycache__ -prune -exec rm -rf {} +
    strip --strip-unneeded $out/bin/python${lib.versions.majorMinor version} $out/lib/python*/lib-dynload/*.so || true
  ''
