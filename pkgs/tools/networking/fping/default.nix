{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "fping-4.1";

  src = fetchurl {
    url = "https://www.fping.org/dist/${name}.tar.gz";
    sha256 = "0wxbvm480vij8dy4v1pi8f0c7010rx6bidg3qhsvkdf2ijhy4cr7";
  };

  configureFlags = [ "--enable-ipv6" "--enable-ipv4" ];

  meta = with stdenv.lib; {
    homepage = http://fping.org/;
    description = "Send ICMP echo probes to network hosts";
    maintainers = with maintainers; [ the-kenny ];
    license = licenses.bsd0;
    platforms = platforms.all;
  };
}
