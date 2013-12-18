{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "fping-3.8";

  src = fetchurl {
    url = "http://www.fping.org/dist/${name}.tar.gz";
    sha256 = "04iwj4x3wns09wp777mb3kwfi7ypb4m9m73p0s2y699px77hcx67";
  };

  meta = {
    homepage = "http://fping.org/";
    description = "Send ICMP echo probes to network hosts";
  };
}
