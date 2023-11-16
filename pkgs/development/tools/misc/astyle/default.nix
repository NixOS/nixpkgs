{ stdenv, lib, fetchurl, cmake }:

stdenv.mkDerivation rec {
  pname = "astyle";
  version = "3.4.10";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-b2fshytDe9PFHg914RLk2/2ybV+3vZz4pIDxCvVVcGM=";
  };

  # lots of hardcoded references to /usr
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace ' /usr/' " $out/"
  '';

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Source code indenter, formatter, and beautifier for C, C++, C# and Java";
    homepage = "https://astyle.sourceforge.net/";
    license = licenses.lgpl3;
    platforms = platforms.unix;
  };
}
