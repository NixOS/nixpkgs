{ lib,
  stdenv,
  fetchurl,
  pkg-config,
  libX11,
  libXfixes,
  libXrandr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xpointerbarrier";
  version = "20.07";

  src = fetchurl {
    url = "https://www.uninformativ.de/git/xpointerbarrier/archives/xpointerbarrier-v${finalAttrs.version}.tar.gz";
    hash = "sha256-V1sNAQjsPVSjJ2nhCSdZqZQA78pjUE0z3IU4+I85CpI=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libX11
    libXfixes
    libXrandr
  ];

  makeFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    homepage = "https://www.uninformativ.de/git/xpointerbarrier/file/README.html";
    description = "Create X11 pointer barriers around your working area";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres xzfc ];
    platforms = platforms.linux;
    mainProgram = "xpointerbarrier";
  };
})
