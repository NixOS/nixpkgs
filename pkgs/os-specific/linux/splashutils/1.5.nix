{stdenv, fetchurl, klibc, zlib, libjpeg}:

stdenv.mkDerivation {
  name = "splashutils-1.5.4.2";

  src = fetchurl {
    url = http://download.berlios.de/fbsplash/splashutils-1.5.4.2.tar.bz2;
    sha256 = "1d28p2wlmgm2cf2dbsxzmgma8gq9nwza43binp2hsscajjy5s9h5";
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
