{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "fping-4.3";

  src = fetchurl {
    url = "https://www.fping.org/dist/${name}.tar.gz";
    sha256 = "0b9ppwibc0dx2ns95m0z1b28939af1c8yvgjbhnr9f7p8bl0l14j";
  };

  configureFlags = [ "--enable-ipv6" "--enable-ipv4" ];

  meta = with stdenv.lib; {
    homepage = "http://fping.org/";
    description = "Send ICMP echo probes to network hosts";
    license = licenses.bsd0;
    platforms = platforms.all;
  };
}
