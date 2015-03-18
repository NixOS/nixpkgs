{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "musl-${version}";
  version = "1.1.6";

  src = fetchurl {
    url    = "http://www.musl-libc.org/releases/${name}.tar.gz";
    sha256 = "1d7inhai37g1ph6yg7ldyl4k5c7i8xvaa5w62n85n3albk2n00as";
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
