{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "fping-4.4";

  src = fetchurl {
    url = "https://www.fping.org/dist/${name}.tar.gz";
    sha256 = "049dnyr6d869kwrnfhkj3afifs3219fy6hv7kmsb3irdlmjlp1cz";
  };

  configureFlags = [ "--enable-ipv6" "--enable-ipv4" ];

  meta = with stdenv.lib; {
    homepage = "http://fping.org/";
    description = "Send ICMP echo probes to network hosts";
    license = licenses.bsd0;
    platforms = platforms.all;
  };
}
