{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "musl-${version}";
  version = "1.1.4";

  src = fetchurl {
    url    = "http://www.musl-libc.org/releases/${name}.tar.gz";
    sha256 = "1kgmi17zpzgjhywmmqxazj8qsx8cf9siwa65jqd2i6rs7jnnb335";
  };

  enableParallelBuilding = true;
  configurePhase = ''
    ./configure --enable-shared --enable-static --prefix=$out --syslibdir=$out/lib
  '';

  meta = {
    description = "An efficient, small, quality libc implementation";
    homepage    = "http://www.musl-libc.org";
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
