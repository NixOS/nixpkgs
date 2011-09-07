{stdenv, fetchurl, linuxHeaders, glibc, libtool, gettext}:

assert stdenv.isLinux && stdenv.system != "powerpc-linux";

stdenv.mkDerivation {
  name = "cpufrequtils-008";
  
  src = fetchurl {
    url = http://kernel.org/pub/linux/utils/kernel/cpufreq/cpufrequtils-008.tar.gz;
    md5 = "52d3e09e47ffef634833f7fab168eccf";
  };

  patchPhase = ''
    sed -e "s@= /usr/bin/@= @g" \
      -e "s@/usr/@$out/@" \
      -i Makefile
  '';

  buildInputs = [ linuxHeaders glibc libtool gettext ];
}
