{ lib, stdenv, fetchfossil }:

stdenv.mkDerivation rec {
  pname = "althttpd";
  version = "unstable-2021-06-09";

  src = fetchfossil {
    url = "https://sqlite.org/althttpd/";
    rev = "0d3b5e232c57e188";
    sha256 = "sha256-vZwpjYYMdP/FgPTAQ9Kdh2RRMovpONqu2v73cCoYyxE=";
  };

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
