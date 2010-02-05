{stdenv, fetchurl, linuxHeaders, glibc, libtool, gettext}:

assert stdenv.isLinux && stdenv.system != "powerpc-linux";

stdenv.mkDerivation {
  name = "cpufrequtils-005";
  
  src = fetchurl {
    url = http://www.kernel.org/pub/linux/utils/kernel/cpufreq/cpufrequtils-005.tar.gz;
    md5 = "100a8220a546ce61ce943d4107e67db9";
  };

  patchPhase = ''
    sed -e "s@= /usr/bin/@= @g" \
      -e "s@/usr/@$out/@" \
      -i Makefile
  '';

  buildInputs = [ linuxHeaders glibc libtool gettext ];
}
