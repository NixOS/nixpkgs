{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "stress";
  version = "1.0.4";

  src = fetchurl {
    url = "https://people.seas.harvard.edu/~apw/stress/stress-${version}.tar.gz";
    sha256 = "0nw210jajk38m3y7h8s130ps2qsbz7j75wab07hi2r3hlz14yzh5";
  };

  meta = with lib; {
    description = "Simple workload generator for POSIX systems. It imposes a configurable amount of CPU, memory, I/O, and disk stress on the system";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
