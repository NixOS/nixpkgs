{ lib, stdenv, fetchfossil }:

stdenv.mkDerivation rec {
  pname = "althttpd";
  version = "unstable-2021-05-07";

  src = fetchfossil {
    url = "https://sqlite.org/althttpd/";
    rev = "2c5e3f9f7051a578";
    sha256 = "sha256-+RuogtQAc+zjCWTOiOunu1pXf3LxfdWYQX+24ysJ7uY=";
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
