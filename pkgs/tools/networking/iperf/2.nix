{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "iperf-2.0.11";

  src = fetchurl {
    url = "mirror://sourceforge/iperf2/files/${name}.tar.gz";
    sha256 = "1lm5inayc8fkqncj55fvzl9611rkmkj212lknmby7c3bgk851mmp";
  };

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/projects/iperf/;
    description = "Tool to measure IP bandwidth using UDP or TCP";
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
