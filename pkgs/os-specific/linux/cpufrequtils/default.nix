{ stdenv, fetchurl, libtool, gettext }:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

stdenv.mkDerivation {
  name = "cpufrequtils-008";

  src = fetchurl {
    url = http://ftp.be.debian.org/pub/linux/utils/kernel/cpufreq/cpufrequtils-008.tar.gz;
    md5 = "52d3e09e47ffef634833f7fab168eccf";
  };

  patchPhase = ''
    sed -e "s@= /usr/bin/@= @g" \
      -e "s@/usr/@$out/@" \
      -i Makefile
  '';

  buildInputs = [ stdenv.gcc.libc.kernelHeaders libtool gettext ];

  meta = {
    description = "Tools to display or change the CPU governor settings";
    platforms = stdenv.lib.platforms.linux;
  };
}
