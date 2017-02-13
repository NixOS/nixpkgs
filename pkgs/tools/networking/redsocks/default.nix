{ stdenv, fetchFromGitHub, libevent }:

let
  pkg = "redsocks";
  version = "0.5";
in
stdenv.mkDerivation rec {
  name = "${pkg}-${version}";

  src = fetchFromGitHub {
    owner = "darkk";
    repo = pkg;
    rev = "release-${version}";
    sha256 = "170cpvvivb6y2kwsqj9ppx5brgds9gkn8mixrnvj8z9c15xhvplm";
  };

  installPhase =
    ''
      mkdir -p $out/{bin,share}
      mv redsocks $out/bin
      mv doc $out/share
    '';

  buildInputs = [ libevent ];

  meta = {
    description = "Transparent redirector of any TCP connection to proxy";
    homepage = http://darkk.net.ru/redsocks/;
    license = stdenv.lib.licenses.asl20;
    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
  };
}
