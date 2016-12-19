{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "iperf-2.0.5";

  src = fetchurl {
    url = "mirror://sourceforge/iperf/${name}.tar.gz";
    sha256 = "0nr6c81x55ihs7ly2dwq19v9i1n6wiyad1gacw3aikii0kzlwsv3";
  };

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    homepage = "http://sourceforge.net/projects/iperf/"; 
    description = "Tool to measure IP bandwidth using UDP or TCP";
    platforms = platforms.unix;
    license = "as-is";
  };
}
