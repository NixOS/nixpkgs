{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "traefik-${version}";
  version = "v1.3.8";

  src = fetchurl {
    url = "https://github.com/containous/traefik/releases/download/${version}/traefik";
    sha256 = "09m8svkqdrvayw871azzcb05dnbhbgb3c2380dw0v4wpcd0rqr9h";
  };

  buildCommand = ''
    mkdir -p $out/bin
    cp $src $out/bin/traefik
    chmod +x $out/bin/traefik
  '';

  meta = with stdenv.lib; {
    homepage = https://traefik.io;
    description = "Træfik, a modern reverse proxy";
    license = licenses.mit;
    maintainers = with maintainers; [ hamhut1066 ];
  };
}
