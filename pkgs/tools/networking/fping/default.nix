{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "fping-3.15";

  src = fetchurl {
    url = "http://www.fping.org/dist/${name}.tar.gz";
    sha256 = "072jhm9wpz1bvwnwgvz24ijw0xwwnn3z3zan4mgr5s5y6ml8z54n";
  };

  configureFlags = [ "--enable-ipv6" "--enable-ipv4" ];

  meta = {
    homepage = "http://fping.org/";
    description = "Send ICMP echo probes to network hosts";
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
    platforms = with stdenv.lib.platforms; all;
  };
}
