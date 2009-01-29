{stdenv, fetchurl, klibc, zlib, libjpeg}:

stdenv.mkDerivation {
  name = "splashutils-1.3";
  
  src = fetchurl {
    url = http://dev.gentoo.org/~spock/projects/splashutils/archive/splashutils-1.3.tar.bz2;
    md5 = "c7c92b98e34b860511aa57bd29d62f76";
  };
  
  patches = [
    ./purity.patch
    ./no-fbsplash.patch
    # Borrowed from http://sources.gentoo.org/viewcvs.py/*checkout*/gentoo-x86/media-gfx/splashutils/files/splashutils-1.3-fdset.patch?rev=1.1.
    ./fdset.patch
  ];

  buildInputs = [klibc zlib libjpeg];
  
  inherit klibc;
  
  dontAddPrefix = 1;
  configureScript = "sh ./configure";
  configureFlags = "--without-ttf --without-png --with-fifo=/var/run/splash_fifo";

  # QUIET = false doesn't work due to the use of /dev/stdout (which
  # doesn't work when the build user doesn't own stdout). 
  #makeFlags = "QUIET=false;

  installPhase = ''
    ensureDir $out/bin
    cp objs/splash_util objs/splash_util.static $out/bin
    ensureDir $out/sbin
    cp objs/splash_helper $out/sbin
  '';

  passthru = {
    helperName = "sbin/splash_helper";
    controlName = "bin/splash_util";
    helperProcFile = "/proc/sys/kernel/fbsplash";
  };
}
