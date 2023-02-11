{ lib, stdenv, fetchfossil, openssl }:

stdenv.mkDerivation rec {
  pname = "althttpd";
  version = "unstable-2022-08-12";

  src = fetchfossil {
    url = "https://sqlite.org/althttpd/";
    rev = "823a1d985d4bacaa";
    sha256 = "sha256-yfVsOfqtHw9ftnK5B4RWeRR/ygfsTEDm7fFSaVxsCas=";
  };

  buildInputs = [ openssl ];

  makeFlags = [ "CC:=$(CC)" ];

  installPhase = ''
    install -Dm755 -t $out/bin althttpd
  '';

  meta = with lib; {
    description = "The Althttpd webserver";
    homepage = "https://sqlite.org/althttpd/";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.all;
  };
}
