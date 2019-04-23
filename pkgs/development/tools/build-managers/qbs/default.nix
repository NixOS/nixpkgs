{ stdenv, fetchFromGitHub, qmake, qtbase, qtscript }:

stdenv.mkDerivation rec {
  name = "qbs-${version}";

  version = "1.12.2";

  src = fetchFromGitHub {
    owner = "qbs";
    repo = "qbs";
    rev = "v${version}";
    sha256 = "0spkkq7nmh27rbx61p23fzkxffx3qdhjqw95pqgsbc76xczd45sv";
  };

  nativeBuildInputs = [ qmake ];

  qmakeFlags = [ "QBS_INSTALL_PREFIX=$(out)" "qbs.pro" ];

  buildInputs = [ qtbase qtscript ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A tool that helps simplify the build process for developing projects across multiple platforms";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ expipiplus1 ];
    platforms = platforms.linux;
  };
}
