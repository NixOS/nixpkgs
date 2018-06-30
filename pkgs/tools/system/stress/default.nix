{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "stress-1.0.4";
 
  src = fetchurl {
    url = "http://people.seas.harvard.edu/~apw/stress/${name}.tar.gz";
    sha256 = "0nw210jajk38m3y7h8s130ps2qsbz7j75wab07hi2r3hlz14yzh5";
  };

  meta = with stdenv.lib; {
    description = "Simple workload generator for POSIX systems. It imposes a configurable amount of CPU, memory, I/O, and disk stress on the system";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
