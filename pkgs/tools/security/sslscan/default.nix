{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "sslscan-${version}";
  version = "1.11.0";

  src = fetchurl {
    url = "https://github.com/rbsec/sslscan/archive/${version}-rbsec.tar.gz";
    sha256 = "19d6vpcihfqs35hni4vigcpqabbnd3sndr5wyvfsladgp40vz3b9";
  };

  buildInputs = [ openssl ];

  installFlags = [
    "BINPATH=$(out)/bin"
    "MANPATH=$(out)/share/man"
  ];

  meta = with stdenv.lib; {
    description = "Tests SSL/TLS services and discover supported cipher suites";
    homepage = https://github.com/rbsec/sslscan;
    license = licenses.gpl3;
    maintainers = with maintainers; [ fpletz globin ];
    platforms = platforms.all;
  };
}

