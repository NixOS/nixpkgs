{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  pkg-config,
  texinfo,
  bison,
  flex,
  glibc,
  zlib,
  zstd,
  gmp,
  mpfr,
  ncurses,
  expat,
  rocdbgapi,
  perl,
  python3,
  babeltrace,
  sourceHighlight,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocgdb";
  version = "7.1.1";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "ROCgdb";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-LDVGO++voqwVMM6RcRtgbXTUvFLTyg/TFdSZanv5Xdc=";
  };

  nativeBuildInputs = [
    pkg-config
    texinfo # For makeinfo
    bison
    flex
    perl # used in mkinstalldirs script during installPhase
    python3
  ];

  buildInputs = [
    zlib
    zstd
    gmp
    mpfr
    ncurses
    expat
    rocdbgapi
    python3
    babeltrace
    sourceHighlight
  ];

  configureFlags = [
    # Ensure we build the amdgpu target
    "--enable-targets=${stdenv.targetPlatform.config},amdgcn-amd-amdhsa"
    "--with-amd-dbgapi=yes"

    "--with-iconv-path=${glibc.bin}"
    "--enable-tui"
    "--with-babeltrace=${babeltrace}"
    "--with-python=python3"
    "--with-system-zlib"
    "--with-system-zstd"
    "--enable-64-bit-bfd"
    "--with-gmp=${gmp.dev}"
    "--with-mpfr=${mpfr.dev}"
    "--with-expat=${expat}"

    # So the installed binary is called "rocgdb" instead on plain "gdb"
    "--program-prefix=roc"

    # Disable building many components not used or incompatible with the amdgcn target
    "--disable-sim"
    "--disable-gdbserver"
    "--disable-ld"
    "--disable-gas"
    "--disable-gdbserver"
    "--disable-gdbtk"
    "--disable-gprofng"
    "--disable-shared"
  ];

  postPatch = ''
    for file in *; do
      if [ -f "$file" ]; then
        patchShebangs "$file"
      fi
    done
  '';

  # The source directory for ROCgdb (based on upstream GDB) contains multiple project
  # of GNU’s toolchain (binutils and onther), we only need to install the GDB part.
  installPhase = ''
    make install-gdb
  '';

  env.CFLAGS = "-Wno-switch -Wno-format-nonliteral -I${zstd.dev}/include -I${zlib.dev}/include -I${expat.dev}/include -I${ncurses.dev}/include";
  env.CXXFLAGS = finalAttrs.env.CFLAGS;

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };

  meta = {
    description = "ROCm source-level debugger for Linux, based on GDB";
    homepage = "https://github.com/ROCm/ROCgdb";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
