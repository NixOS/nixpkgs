{ stdenv, fetchurl, lib, nixosTests }:

stdenv.mkDerivation rec {
  pname = "wiki-js";
  version = "2.5.191";

  src = fetchurl {
    url = "https://github.com/Requarks/wiki/releases/download/${version}/${pname}.tar.gz";
    sha256 = "sha256-lEHelZTFZxcds7t3TCMcd9b3rKdml54A0/V7gcQIyPA=";
  };

  buildCommand = ''
    mkdir $out
    tar xzvf $src -C $out
  '';

  passthru.tests = { inherit (nixosTests) wiki-js; };

  meta = with lib; {
    homepage = "https://js.wiki/";
    description = "A modern and powerful wiki app built on Node.js";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ma27 ];
  };
}
