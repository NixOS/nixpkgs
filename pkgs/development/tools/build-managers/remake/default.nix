{ stdenv, fetchurl, readline }:

stdenv.mkDerivation rec {
  name = "remake-${version}";
  version = "3.82+dbg-0.6";

  src = fetchurl {
    url = "mirror://sourceforge/project/bashdb/remake/${version}/${name}.tar.bz2";
    sha256 = "0i2g6vi9zya78d9zpigfnmzg2qcl93myjfibh3kfmjk7b9lajfyz";
  };

  buildInputs = [ readline ];

  meta = {
    homepage = http://bashdb.sourceforge.net/remake/;
    license = stdenv.lib.licenses.gpl3;
    description = "GNU Make with comprehensible tracing and a debugger";
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ bjornfor ];
  };
}
