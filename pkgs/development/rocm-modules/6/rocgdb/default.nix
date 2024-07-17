{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  pkg-config,
  texinfo,
  bison,
  flex,
  zlib,
  elfutils,
  gmp,
  ncurses,
  expat,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocgdb";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "ROCgdb";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-XeX/k8gfo9HgcUSIjs35C7IqCmFhvBOqQJSOoPF6HK4=";
  };

  nativeBuildInputs = [
    pkg-config
    texinfo # For makeinfo
    bison
    flex
  ];

  buildInputs = [
    zlib
    elfutils
    gmp
    ncurses
    expat
  ];

  # `-Wno-format-nonliteral` doesn't work
  env.NIX_CFLAGS_COMPILE = "-Wno-error=format-security";

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "ROCm source-level debugger for Linux, based on GDB";
    homepage = "https://github.com/ROCm/ROCgdb";
    license = with licenses; [
      gpl2
      gpl3
      bsd3
    ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken = versionAtLeast finalAttrs.version "7.0.0";
  };
})
