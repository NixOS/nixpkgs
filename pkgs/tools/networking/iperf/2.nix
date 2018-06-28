{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "iperf-2.0.12";

  src = fetchurl {
    url = "mirror://sourceforge/iperf2/files/${name}.tar.gz";
    sha256 = "0ii6sgp62x9ly2gyk00w58dy9qwcw2kvhhcfa7v16jr6n4gnazrn";
  };

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/projects/iperf/;
    description = "Tool to measure IP bandwidth using UDP or TCP";
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
