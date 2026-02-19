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
}:
let
  inherit (import ./common.nix { inherit lib; }) meta;
  pname = "binutils-static";
  version = "2.45.1";

  src = fetchurl {
    url = "mirror://gnu/binutils/binutils-${version}.tar.xz";
    hash = "sha256-X+EB5v6dGP3slZYtge1nD97l834/SPC++Hvd+GJROqU=";
  };

  patches = [
    # Make binutils output deterministic by default.
    ./deterministic.patch
  ];

  configureFlags = [
    "CC=musl-gcc"
    "LDFLAGS=--static"
    "--prefix=${placeholder "out"}"
    "--build=${buildPlatform.config}"
    "--host=${hostPlatform.config}"

    "--disable-dependency-tracking"

    "--with-sysroot=/"
    "--enable-deterministic-archives"
    # depends on bison
    "--disable-gprofng"

    # Turn on --enable-new-dtags by default to make the linker set
    # RUNPATH instead of RPATH on binaries.  This is important because
    # RUNPATH can be overridden using LD_LIBRARY_PATH at runtime.
    "--enable-new-dtags"

    # By default binutils searches $libdir for libraries. This brings in
    # libbfd and libopcodes into a default visibility. Drop default lib
    # path to force users to declare their use of these libraries.
    "--with-lib-path=:"
  ];
in
bash.runCommand "${pname}-${version}"
  {
    inherit pname version meta;

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
        ${result}/bin/ld --version
        mkdir $out
      '';
  }
  ''
    # Unpack
    tar xf ${src}
    cd binutils-${version}

    # Patch
    ${lib.concatMapStringsSep "\n" (f: "patch -Np1 -i ${f}") patches}

    # Configure
    bash ./configure ${lib.concatStringsSep " " configureFlags}

    # Build
    make -j $NIX_BUILD_CORES

    # Install
    # strip to remove build dependency store path references
    make -j $NIX_BUILD_CORES install-strip
  ''
