{ stdenv, fetchurl, erlang }:

stdenv.mkDerivation {
  name = "rebar-2.1.0-pre";

  src = fetchurl {
    url = "https://github.com/basho/rebar/archive/2.1.0-pre.tar.gz";
    sha256 = "0dsbk9ssvk1hx9275900dg4bz79kpwcid4gsz09ziiwzv0jjbrjn";
  };

  buildInputs = [ erlang ];

  buildPhase = "escript bootstrap";
  installPhase = ''
    mkdir -p $out/bin
    cp rebar $out/bin/rebar
  '';
}
