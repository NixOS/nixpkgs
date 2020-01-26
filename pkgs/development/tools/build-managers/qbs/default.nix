{ stdenv, fetchFromGitHub, qmake, qtbase, qtscript }:

stdenv.mkDerivation rec {
  pname = "qbs";

  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "qbs";
    repo = "qbs";
    rev = "v${version}";
    sha256 = "0hq2lx5w5lsiy9c69bcps4wyn2sa9s88hj0bq95p93sfiwq6mxlr";
  };

  nativeBuildInputs = [ qmake ];

  qmakeFlags = [ "QBS_INSTALL_PREFIX=$(out)" "qbs.pro" ];

  buildInputs = [ qtbase qtscript ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A tool that helps simplify the build process for developing projects across multiple platforms";
    homepage = "https://wiki.qt.io/Qbs";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ expipiplus1 ];
    platforms = platforms.linux;
  };
}
