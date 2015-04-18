{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "fping-3.10";

  src = fetchurl {
    url = "http://www.fping.org/dist/${name}.tar.gz";
    sha256 = "1n2psfxgww6wg5rz8rly06xkghgp8lshx2lx6rramrigyd1fhiyd";
  };

  meta = {
    homepage = "http://fping.org/";
    description = "Send ICMP echo probes to network hosts";
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
    platforms = with stdenv.lib.platforms; all;
  };
}
