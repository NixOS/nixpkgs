{
  lib,
  buildPlatform,
  hostPlatform,
  targetPlatform,
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
  tinycc ? null,
  gcc ? null,
  binutils ? null,
  musl ? null,
}:
let
  # Based on https://github.com/ZilchOS/bootstrap-from-tcc/blob/2e0c68c36b3437386f786d619bc9a16177f2e149/using-nix/2a1-static-binutils.nix
  inherit (import ./common.nix { inherit lib; }) meta;
  pname = "binutils";
  version = "2.46.0";

  src = fetchurl {
    url = "mirror://gnu/binutils/binutils-${version}.tar.xz";
    hash = "sha256-11qU9Nc+ekCG91E+Z+Q56Pzcu3Jv/mP0ZhdE5iVrLPI=";
  };

  patches = [
    # Make binutils output deterministic by default.
    ./deterministic.patch
    # Fix __attribute__, to fix mmap-related assertion failures.
    ./fix-tinycc-attribute.patch
  ];

  enableShared = !hostPlatform.isStatic;
  targetPrefix = lib.optionalString (
    targetPlatform.config != hostPlatform.config
  ) "${targetPlatform.config}-";

  configureFlags = [
    "--prefix=${placeholder "out"}"
    "--build=${buildPlatform.config}"
    "--host=${hostPlatform.config}"
    "--target=${targetPlatform.config}"
    "--program-prefix=${targetPrefix}"
    "--with-sysroot=/"
    "--disable-dependency-tracking"
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
  ]
  ++ (
    if enableShared then
      [
        "--enable-shared"
        "--disable-static"
      ]
    else
      [
        "--disable-shared"
        "--enable-static"
      ]
  );

  cc = if gcc != null then "gcc" else "${lib.getExe' tinycc.compiler "tcc"} -B ${tinycc.libs}/lib";
  ar = if binutils != null then "ar" else "${lib.getExe' tinycc.compiler "tcc"} -ar";
in
bash.runCommand "${pname}-${version}"
  {
    inherit pname version meta;

    nativeBuildInputs = [
      gnumake
      gnupatch
      gnused
      gnugrep
      gawk
      diffutils
      gnutar
      xz
    ]
    ++ lib.optional (tinycc != null) tinycc.compiler
    ++ lib.optional (gcc != null) gcc
    ++ lib.optional (binutils != null) binutils;

    passthru.tests.get-version =
      result:
      bash.runCommand "${pname}-get-version-${version}" { } ''
        ${result}/bin/ld --version
        mkdir $out
      '';
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
    export CC="${cc}"
    export AR="${ar}"
    export lt_cv_sys_max_cmd_len=32768
    # elf.c with mmap() seems unstable for some reason
    export ac_cv_func_mmap_fixed_mapped=no

    export CFLAGS="-D__LITTLE_ENDIAN__=1"
    bash ./configure ${lib.concatStringsSep " " configureFlags}

    # Build
    make -j $NIX_BUILD_CORES all-libiberty all-gas all-bfd all-libctf all-zlib all-gprof
    make all-ld # race condition on ld/.deps/ldwrite.Po, serialize
    make -j $NIX_BUILD_CORES

    # Install
    make -j $NIX_BUILD_CORES install
  ''
