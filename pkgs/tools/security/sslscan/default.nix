{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "sslscan-${version}";
  version = "1.11.5";

  src = fetchurl {
    url = "https://github.com/rbsec/sslscan/archive/${version}-rbsec.tar.gz";
    sha256 = "0mcg8hyx1r9sq716bw1r554fcsf512khgcms2ixxb1c31ng6lhq6";
  };

  buildInputs = [ openssl ];

  installFlags = [
    "PREFIX=$(out)"
  ];

  meta = with stdenv.lib; {
    description = "Tests SSL/TLS services and discover supported cipher suites";
    homepage = https://github.com/rbsec/sslscan;
    license = licenses.gpl3;
    maintainers = with maintainers; [ fpletz globin ];
    platforms = platforms.all;
  };
}

