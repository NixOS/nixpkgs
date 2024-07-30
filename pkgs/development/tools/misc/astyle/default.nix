{ stdenv, lib, fetchurl, cmake }:

stdenv.mkDerivation rec {
  pname = "astyle";
  version = "3.5.2";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    hash = "sha256-2wwKctQOZAwgHjnmRni2/jFvN+fvBfZ84rItVVwKbRI=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Source code indenter, formatter, and beautifier for C, C++, C# and Java";
    mainProgram = "astyle";
    homepage = "https://astyle.sourceforge.net/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ carlossless ];
    platforms = platforms.unix;
  };
}
