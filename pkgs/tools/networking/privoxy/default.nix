{stdenv, fetchurl, autoconf, automake, zlib, pcre, w3m}:

stdenv.mkDerivation {
  name = "privoxy-3.0.21";

  src = fetchurl {
    url = mirror://sourceforge/ijbswa/Sources/3.0.21%20%28stable%29/privoxy-3.0.21-stable-src.tar.gz;
    sha256 = "1f6xb7aa47p90c26vqaw74y6drs9gpnhxsgby3mx0awdjh0ydisy";
  };

  buildInputs = [automake autoconf zlib pcre w3m];

  preConfigure = ''
    autoheader
    autoconf
  '';
}
