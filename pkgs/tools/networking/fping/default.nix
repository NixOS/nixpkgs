{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "fping-3.16";

  src = fetchurl {
    url = "http://www.fping.org/dist/${name}.tar.gz";
    sha256 = "2f753094e4df3cdb1d99be1687c0fb7d2f14c0d526ebf03158c8c5519bc78f54";
  };

  configureFlags = [ "--enable-ipv6" "--enable-ipv4" ];

  meta = {
    homepage = "http://fping.org/";
    description = "Send ICMP echo probes to network hosts";
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
    platforms = with stdenv.lib.platforms; all;
  };
}
