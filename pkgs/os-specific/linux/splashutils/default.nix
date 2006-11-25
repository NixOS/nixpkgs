{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "splashutils-1.3";
  src = fetchurl {
    url = http://dev.gentoo.org/~spock/projects/splashutils/archive/splashutils-1.3.tar.bz2;
    md5 = "c7c92b98e34b860511aa57bd29d62f76";
  };
  patches = [./no-fbsplash.patch];
  
  dontAddPrefix = 1;
  configureScript = "sh ./configure";
  configureFlags = "--without-ttf --without-png --without-fbsplash";

  # Hack hack hack.
  makeFlags = "KLCC=gcc";
  NIX_CFLAGS_COMPILE = "-Iobjs/jpeglib -Ilibs/jpeg-6b -Ilibs/freetype-2.1.9/include -Ilibs/libpng-1.2.8 -Ilibs/zlib-1.2.3";
  NIX_CFLAGS_LINK = "-Lobjs/jpeglib -Lobjs/freetype2/.libs -Llibs/zlib-1.2.3 -Llibs/libpng-1.2.8";

  installPhase = "ensureDir $out/bin; cp objs/splash_helper objs/splash_util objs/splash_util.static $out/bin";
}
