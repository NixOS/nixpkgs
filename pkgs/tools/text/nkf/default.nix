{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "nkf-${version}";
  version = "2.1.3";

  src = fetchurl {
    url = "mirror://sourceforgejp/nkf/59912/${name}.tar.gz";
    sha256 = "8cb430ae69a1ad58b522eb4927b337b5b420bbaeb69df255919019dc64b72fc2";
  };

  makeFlags = "prefix=\${out}";

  meta = {
    description = "Tool for converting encoding of Japanese text";
    homepage = "http://sourceforge.jp/projects/nkf/";
    license = stdenv.lib.licenses.zlib;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.auntie ];
  };
}
