{ stdenv, fetchFromGitHub, openssl }:

stdenv.mkDerivation rec {
  name = "sslscan-${version}";
  version = "1.11.12";

  src = fetchFromGitHub {
    owner = "rbsec";
    repo = "sslscan";
    rev = "${version}-rbsec";
    sha256 = "0wa0z6my6aqjp8si6x522ivk0yy55izbs3ch298gxjw5r15f4jb1";
  };

  buildInputs = [ openssl ];

  makeFlags = [ "PREFIX=$(out)" "CC=cc" ];

  meta = with stdenv.lib; {
    description = "Tests SSL/TLS services and discover supported cipher suites";
    homepage = https://github.com/rbsec/sslscan;
    license = licenses.gpl3;
    maintainers = with maintainers; [ fpletz globin ];
    platforms = platforms.all;
  };
}
