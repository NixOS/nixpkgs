{stdenv, fetchurl, klibc, zlib, libjpeg}:

stdenv.mkDerivation {
  name = "splashutils-1.4";
  src = fetchurl {
    url = http://dev.gentoo.org/~spock/projects/gensplash/archive/splashutils-1.4.tar.bz2;
    sha256 = "1j4jv8yyfdl2nbl6r2kgw5pznih55v7zsxzywcg28z7cyrf49jg2";
  };

  buildInputs = [klibc zlib libjpeg];
  
  inherit klibc;
  
  dontAddPrefix = 1;
  configureScript = "sh ./configure";
  configureFlags = "--without-ttf --without-png --without-gpm --with-fifo=/var/run/splash_fifo";

  # QUIET = false doesn't work due to the use of /dev/stdout (which
  # doesn't work when the build user doesn't own stdout). 
  #makeFlags = "QUIET=false;

  preBuild = "
    makeFlagsArray=(INSTALL='install -c')
    substituteInPlace Makefile --replace '/usr/$(LIB)/klibc' ${klibc}/lib/klibc
  ";

  installPhase = "
    ensureDir $out/bin
    cp objs/splash_helper objs/splash_util objs/splash_util.static $out/bin
  ";
}
