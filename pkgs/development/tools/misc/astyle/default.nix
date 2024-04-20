{ stdenv, lib, fetchurl, cmake }:

stdenv.mkDerivation rec {
  pname = "astyle";
  version = "3.4.13";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    hash = "sha256-eKYQq9OelOD5E+nuXNoehbtizWM1U97LngDT2SAQGc4=";
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
