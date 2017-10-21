{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "nkf-${version}";
  version = "2.1.4";

  src = fetchurl {
    url = "mirror://sourceforgejp/nkf/64158/${name}.tar.gz";
    sha256 = "b4175070825deb3e98577186502a8408c05921b0c8ff52e772219f9d2ece89cb";
  };

  makeFlags = "prefix=\${out}";

  meta = {
    description = "Tool for converting encoding of Japanese text";
    homepage = http://sourceforge.jp/projects/nkf/;
    license = stdenv.lib.licenses.zlib;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.auntie ];
  };
}
