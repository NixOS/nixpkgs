{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchpatch,
  mingw_w64_headers,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cygwin-headers";
  version = "3.5.4";

  src = fetchFromGitHub {
    owner = "mirror";
    repo = "newlib-cygwin";
    rev = "cygwin-${finalAttrs.version}";
    hash = "sha256-ZfT6JhOXLCJOY0vSVz6aKShmtuTN9/0NZ1k1RMSZX4Q=";
  };

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/Windows-on-ARM-Experiments/mingw-woarm64-build/371102dfa23b3e56b6759e1a44026d0640d55223/patches/cygwin/0001-before-autogen.patch";
      sha256 = "sha256-1JsbfYAPpsQSjknZcKfJOHA0RcdmgzkzAI4RcHG1kpA=";
    })
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/include/
    ln -s ${mingw_w64_headers}/include/w32api $out/include/
    cp -r newlib/libc/include/* $out/include/
    cp -r winsup/cygwin/include/* $out/include/
  '';

  meta = {
    platforms = lib.platforms.windows;
  };
})
