{stdenv, fetchurl, klibc, zlib, libjpeg}:

stdenv.mkDerivation {
  name = "splashutils-1.5.4.1";

  src = fetchurl {
    url = http://download.berlios.de/fbsplash/splashutils-1.5.4.1.tar.bz2;
    sha256 = "0pwv9l6a042hhcwpi4kqdzjg7d1mrlix0fvgqqzqh93mc54z9lf7";
  };

  buildInputs = [klibc zlib libjpeg];
  
  configureFlags = "--without-ttf --without-png --without-gpm --with-themedir=/etc/splash";

  preConfigure = ''
    configureFlags="$configureFlags --with-essential-prefix=$out"
    substituteInPlace src/common.h \
      --replace 'FBSPLASH_DIR"/sys"' '"/sys"' \
      --replace 'FBSPLASH_DIR"/proc"' '"/proc"'
  '';

  CPP = "gcc -E";
  CXXCPP = "g++ -E";

  passthru = {
    helperName = "sbin/fbcondecor_helper";
    controlName = "sbin/fbcondecor_ctl";
    helperProcFile = "/proc/sys/kernel/fbcondecor";
  };
}
