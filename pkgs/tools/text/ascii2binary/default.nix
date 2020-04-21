{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "ascii2binary";
  version = "2.14";

  src = fetchurl {
    # The "normal" url gives a 404.
    # url = "https://billposer.org/Software/Downloads/${pname}-${version}.tar.bz2";
    # Use Debian's mirror instead:
    url = "mirror://debian/pool/main/a/${pname}/${pname}_${version}.orig.tar.gz";
    sha256 = "1a9md30a60mrr6jri172m88ni5ygj1i8ghdzfgjksl6w5cmk7p5d";
  };

  meta = with stdenv.lib; {
    description = "Convert between ASCII, hexadecimal and binary representations";
    homepage = "https://www.billposer.org/software.html";
    maintainers = with maintainers; [ synthetica ];
  };
}
