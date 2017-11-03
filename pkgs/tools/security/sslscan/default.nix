{ stdenv, fetchFromGitHub, openssl }:

stdenv.mkDerivation rec {
  name = "sslscan-${version}";
  version = "1.11.10";

  src = fetchFromGitHub {
    owner = "rbsec";
    repo = "sslscan";
    rev = "${version}-rbsec";
    sha256 = "1bxr7p7nhg4b8wkcm7j2xk10gf370sqcvl06vbgnqd3azp55fhpf";
  };

  buildInputs = [ openssl ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Tests SSL/TLS services and discover supported cipher suites";
    homepage = https://github.com/rbsec/sslscan;
    license = licenses.gpl3;
    maintainers = with maintainers; [ fpletz globin ];
    platforms = platforms.all;
  };
}
