{ stdenv, fetchurl, nettle }:

stdenv.mkDerivation rec {
  pname = "rdfind";
  version = "1.4.1";

  src = fetchurl {
    url = "https://rdfind.pauldreik.se/${pname}-${version}.tar.gz";
    sha256 = "132y3wwgnbpdx6f90q0yahd3nkr4cjzcy815ilc8p97b4vn17iih";
  };

  buildInputs = [ nettle ];

  meta = with stdenv.lib; {
    homepage = https://rdfind.pauldreik.se/;
    description = "Removes or hardlinks duplicate files very swiftly";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ maintainers.wmertens ];
    platforms = platforms.all;
  };
}
