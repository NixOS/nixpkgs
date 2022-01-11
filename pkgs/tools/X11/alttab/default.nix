{ lib, stdenv, coreutils, fetchFromGitHub, autoconf, automake, pkg-config, procps, ronn,
libpng, uthash , which, xnee, xorg, python3Packages }:

stdenv.mkDerivation rec {
  version = "1.6.1";

  pname = "alttab";

  src = fetchFromGitHub {
    owner = "sagb";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-g56207IGNDnBIqZmbpcgOLcfAGKwBE0DYu2Dq0bLS8o=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
    ronn
  ];

  preConfigure = "./bootstrap.sh";

  buildInputs = [
    libpng
    uthash
    xorg.libX11
    xorg.libXft
    xorg.libXmu
    xorg.libXpm
    xorg.libXrandr
    xorg.libXrender
  ];

  enableParallelBuilding = true;

  doCheck = true;

  checkInputs = [
    coreutils
    procps
    python3Packages.xvfbwrapper
    which
    xnee
    xorg.xeyes
    xorg.xprop
  ];

  meta = with lib; {
    homepage = "https://github.com/sagb/alttab";
    description = "X11 window switcher designed for minimalistic window managers or standalone X11 session";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.sgraf ];
  };
}
