{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "musl-${version}";
  version = "1.1.11";

  src = fetchurl {
    url    = "http://www.musl-libc.org/releases/${name}.tar.gz";
    sha256 = "0grmmah3d9wajii26010plpinv3cbiq3kfqsblgn84kv3fjnv7mv";
  };

  enableParallelBuilding = true;

  preConfigure = ''
    configureFlagsArray+=("--syslibdir=$out/lib")
  '';

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
