{
  lib,
  buildPlatform,
  hostPlatform,
  fetchurl,
  bash,
  coreutils,
  gnumake,
  gnupatch,
  gnused,
  gnugrep,
  gawk,
  diffutils,
  gnutar,
  xz,
  tinycc,
}:

let
  # Based on https://github.com/ZilchOS/bootstrap-from-tcc/blob/2e0c68c36b3437386f786d619bc9a16177f2e149/using-nix/2a1-static-binutils.nix
  pname = "binutils";
  version = "2.41";

  src = fetchurl {
    url = "mirror://gnu/binutils/binutils-${version}.tar.xz";
    hash = "sha256-rppXieI0WeWWBuZxRyPy0//DHAMXQZHvDQFb3wYAdFA=";
  };

  patches = [
    # Make binutils output deterministic by default.
    ./deterministic.patch
  ];

  configureFlags = [
    "--prefix=${placeholder "out"}"
    "--build=${buildPlatform.config}"
    "--host=${hostPlatform.config}"
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
    inherit pname version;

    nativeBuildInputs = [
      tinycc.compiler
      gnumake
      gnupatch
      gnused
      gnugrep
      gawk
      diffutils
      gnutar
      xz
    ];

    passthru.tests.get-version =
      result:
      bash.runCommand "${pname}-get-version-${version}" { } ''
        ${result}/bin/ld --version
        mkdir $out
      '';

    meta = with lib; {
      description = "Tools for manipulating binaries (linker, assembler, etc.)";
      homepage = "https://www.gnu.org/software/binutils";
      license = licenses.gpl3Plus;
      teams = [ teams.minimal-bootstrap ];
      platforms = platforms.unix;
    };
  }
  ''
    # Unpack
    cp ${src} binutils.tar.xz
    unxz binutils.tar.xz
    tar xf binutils.tar
    rm binutils.tar
    cd binutils-${version}

    # Patch
    ${lib.concatMapStringsSep "\n" (f: "patch -Np1 -i ${f}") patches}
    sed -i 's|/bin/sh|${bash}/bin/bash|' \
      missing install-sh mkinstalldirs
    # see libtool's 74c8993c178a1386ea5e2363a01d919738402f30
    sed -i 's/| \$NL2SP/| sort | $NL2SP/' ltmain.sh
    # alias makeinfo to true
    mkdir aliases
    ln -s ${coreutils}/bin/true aliases/makeinfo
    export PATH="$(pwd)/aliases/:$PATH"

    # Configure
    export CC="tcc -B ${tinycc.libs}/lib"
    export AR="tcc -ar"
    export lt_cv_sys_max_cmd_len=32768
    export CFLAGS="-D__LITTLE_ENDIAN__=1"
    bash ./configure ${lib.concatStringsSep " " configureFlags}

    # Build
    make -j $NIX_BUILD_CORES all-libiberty all-gas all-bfd all-libctf all-zlib all-gprof
    make all-ld # race condition on ld/.deps/ldwrite.Po, serialize
    make -j $NIX_BUILD_CORES

    # Install
    make -j $NIX_BUILD_CORES install
  ''
