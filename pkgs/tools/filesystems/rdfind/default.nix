{ stdenv, fetchurl, nettle }:

stdenv.mkDerivation rec {
  name = "rdfind-${version}";
  version = "1.3.5";

  src = fetchurl {
    url = "https://rdfind.pauldreik.se/${name}.tar.gz";
    sha256 = "0i63f2lwwkiq5m8shi3wwi59i1s25r6dx6flsgqxs1jvlcg0lvn3";
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
