{ stdenv, lib, fetchurl, cmake }:

stdenv.mkDerivation rec {
  pname = "astyle";
  version = "3.1";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}_${version}_linux.tar.gz";
    sha256 = "1ms54wcs7hg1bsywqwf2lhdfizgbk7qxc9ghasxk8i99jvwlrk6b";
  };

  # lots of hardcoded references to /usr
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace ' /usr/' " $out/"
  '';

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Source code indenter, formatter, and beautifier for C, C++, C# and Java";
    homepage = "http://astyle.sourceforge.net/";
    license = licenses.lgpl3;
    platforms = platforms.unix;
  };
}
