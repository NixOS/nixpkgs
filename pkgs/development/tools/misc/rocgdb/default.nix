{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, pkg-config
, texinfo
, bison
, flex
, zlib
, elfutils
, gmp
, ncurses
, expat
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocgdb";
  version = "5.4.1";

  src = fetchFromGitHub {
    owner = "ROCm-Developer-Tools";
    repo = "ROCgdb";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-DORPvfon32+rIk+YcO9LlUefNvvC7trmiTswg9MMuIs=";
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
  NIX_CFLAGS_COMPILE = "-Wno-error=format-security";

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "ROCm source-level debugger for Linux, based on GDB";
    homepage = "https://github.com/ROCm-Developer-Tools/ROCgdb";
    license = with licenses; [ gpl2 gpl3 bsd3 ];
    maintainers = teams.rocm.members;
  };
})
