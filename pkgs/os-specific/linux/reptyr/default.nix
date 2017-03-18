{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "0.6.2";
  name = "reptyr-${version}";
  src = fetchurl {
    url = "https://github.com/nelhage/reptyr/archive/reptyr-${version}.tar.gz";
    sha256 = "07pfl0rkgm8m3f3jy8r9l2yvnhf8lgllpsk3mh57mhzdxq8fagf7";
  };

  # Avoid a glibc >= 2.25 deprecation warning that gets fatal via -Werror.
  postPatch = ''
    sed 1i'#include <sys/sysmacros.h>' -i platform/linux/linux.c
  '';

  makeFlags = ["PREFIX=$(out)"];
  meta = {
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [raskin];
    license = stdenv.lib.licenses.mit;
    description = ''A Linux tool to change controlling pty of a process'';
  };
}
