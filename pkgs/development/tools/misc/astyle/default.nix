{ stdenv, lib, fetchurl, cmake }:

stdenv.mkDerivation rec {
  pname = "astyle";
  version = "3.4.16";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    hash = "sha256-y3YENPfkYk1e6yd2rDNOeeARGb6kGfyYbt0sJNk4A2Q=";
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
