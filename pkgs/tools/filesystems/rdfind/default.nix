{ stdenv, fetchurl, nettle }:

stdenv.mkDerivation rec {
  name = "rdfind-${version}";
  version = "1.3.4";

  src = fetchurl {
    url = "http://rdfind.pauldreik.se/${name}.tar.gz";
    sha256 = "0zfc5whh6j5xfbxr6wvznk62qs1mkd3r7jcq72wjgnck43vv7w55";
  };

  buildInputs = [ nettle ];

  meta = {
    homepage = http://rdfind.pauldreik.se/;
    description = "Removes or hardlinks duplicate files very swiftly";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ wmertens ];
    platforms = with stdenv.lib.platforms; all;
  };
}
