{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "musl-${version}";
  version = "1.1.7";

  src = fetchurl {
    url    = "http://www.musl-libc.org/releases/${name}.tar.gz";
    sha256 = "168mz5mwmzr5j6l4jxnwaxw6l89xycql3vfk01jsmy7chziamq6q";
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
