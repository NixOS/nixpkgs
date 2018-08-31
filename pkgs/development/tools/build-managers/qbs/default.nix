{ stdenv, qt5, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "qbs-${version}";

  version = "1.12";

  src = fetchFromGitHub {
    owner = "qt-labs";
    repo = "qbs";
    rev = "2440b19b288096e1601674de2ac15c560af469cd";
    sha256 = "1r90w4d3cvpk8xprn704v5zjgg0ngmvzmzx4xgrxf6m826fq3j3k";
  };

  enableParallelBuilding = true;

  buildInputs = with qt5; [
    qtbase
    qtscript
  ];

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  buildPhase = ''
    # From http://doc.qt.io/qbs/building.html
    qmake -r qbs.pro
    make
  '';

  postInstall = ''
    mv $out/usr/local/* "$out"
  '';

  meta = with stdenv.lib; {
    description = "A tool that helps simplify the build process for developing projects across multiple platforms";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ expipiplus1 ];
    inherit version;
    platforms = platforms.linux;
  };
}
