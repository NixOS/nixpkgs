{ stdenv, fetchFromGitHub, qmake, qtbase, qtscript }:

stdenv.mkDerivation rec {
  name = "qbs-${version}";

  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "qbs";
    repo = "qbs";
    rev = "v${version}";
    sha256 = "14b7bz07yfrmbry57n3xh8w4nbapm6aknk45fgi7ljvsfzp85fzl";
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
