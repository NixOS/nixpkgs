{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "musl-${version}";
  version = "1.0.0";

  src = fetchurl {
    url    = "http://www.musl-libc.org/releases/${name}.tar.gz";
    sha256 = "0chs9h8k4d0iwv8w7n1w02nll3ypwqa2gag6r4czznkj55fz9mqs";
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
