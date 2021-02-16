{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, intltool
, libxml2
, pciutils
, pkg-config
, gtk2
, ddccontrol-db
}:

stdenv.mkDerivation rec {
  pname = "ddccontrol";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "ddccontrol";
    repo = "ddccontrol";
    rev = "0.5.1";
    sha256 = "sha256-e6Rzzz5S+Um2ZBuUkfAJQA4V+zqCqsUHB0f1t/dTU2w=";
  };

  nativeBuildInputs = [
    autoreconfHook
    intltool
    pkg-config
  ];

  buildInputs = [
    libxml2
    pciutils
    gtk2
    ddccontrol-db
  ];

  prePatch = ''
    oldPath="\$""{datadir}/ddccontrol-db"
    newPath="${ddccontrol-db}/share/ddccontrol-db"
    sed -i -e "s|$oldPath|$newPath|" configure.ac
    sed -i -e "s/chmod 4711/chmod 0711/" src/ddcpci/Makefile*
  '';

  preConfigure = ''
    intltoolize --force
  '';

  meta = with lib; {
    description = "A program used to control monitor parameters by software";
    homepage = "https://github.com/ddccontrol/ddccontrol";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with lib.maintainers; [ pakhfn ];
  };
}
