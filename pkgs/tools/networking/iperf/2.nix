{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "iperf-2.0.9";

  src = fetchurl {
    url = "mirror://sourceforge/iperf2/files/${name}.tar.gz";
    sha256 = "1gzh8dk2myqgxznxrryib4zsw23ffvx0s5j7sa780vk86lgr20nv";
  };

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/projects/iperf/;
    description = "Tool to measure IP bandwidth using UDP or TCP";
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
