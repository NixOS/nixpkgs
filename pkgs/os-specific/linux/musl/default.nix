{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "musl-${version}";
  version = "1.1.10";

  src = fetchurl {
    url    = "http://www.musl-libc.org/releases/${name}.tar.gz";
    sha256 = "0z4b3j1r0v4zr3v1cpl1v56zx6w8nq1y3wbs8x1zg87pqyqykfs5";
  };

  enableParallelBuilding = true;

  configureFlags = [
    "--enable-shared"
    "--enable-static"
  ];

  dontDisableStatic = true;

  meta = {
    description = "An efficient, small, quality libc implementation";
    homepage    = "http://www.musl-libc.org";
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
