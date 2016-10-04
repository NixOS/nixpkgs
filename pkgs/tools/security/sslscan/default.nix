{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "sslscan-${version}";
  version = "1.11.7";

  src = fetchurl {
    url = "https://github.com/rbsec/sslscan/archive/${version}-rbsec.tar.gz";
    sha256 = "0wygz2gm9asvhpfy44333y4pkdja1sbr41hc6mhkxg7a4ys8f9qs";
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

