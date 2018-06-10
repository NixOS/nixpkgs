{ stdenv, qt5, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "qbs-${version}";

  version = "1.8";

  src = fetchFromGitHub {
    owner = "qt-labs";
    repo = "qbs";
    rev = "fa9c21d6908e0dad805113f570ac883c1dc5067a";
    sha256 = "1manriz75rav1vldkk829yk1la9md4m872l5ykl9m982i9801d9g";
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
