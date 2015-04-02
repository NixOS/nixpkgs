{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "musl-${version}";
  version = "1.1.8";

  src = fetchurl {
    url    = "http://www.musl-libc.org/releases/${name}.tar.gz";
    sha256 = "04vq4a1hm81kbxfcqa30s6xpzbqf3568gbysfxcmb72v8438b4ps";
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
