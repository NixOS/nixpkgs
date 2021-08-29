{ lib, stdenv, fetchurl, cmake, qt4 }:

stdenv.mkDerivation rec {
  pname = "automoc4";
  version = "0.9.88";

  src = fetchurl {
    url = "mirror://kde/stable/automoc4/0.9.88/${pname}.tar.bz2";
    sha256 = "0jackvg0bdjg797qlbbyf9syylm0qjs55mllhn11vqjsq3s1ch93";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qt4 ];

  meta = with lib; {
    homepage = "https://techbase.kde.org/Development/Tools/Automoc4";
    description = "KDE Meta Object Compiler";
    license = licenses.bsd2;
    maintainers = [ maintainers.sander ];
    platforms = platforms.unix;
  };
}
