{ stdenv, fetchurl, postgresql, ruby, makeWrapper, nodejs-6_x }:

with stdenv.lib;
stdenv.mkDerivation rec {
  version = "3.43.2";
  name = "heroku-${version}";

  meta = {
    homepage = "https://toolbelt.heroku.com";
    description = "Everything you need to get started using Heroku";
    maintainers = with maintainers; [ aflatter mirdhyn ];
    license = licenses.mit;
  };

  src = fetchurl {
    url = "https://s3.amazonaws.com/assets.heroku.com/heroku-client/heroku-client-${version}.tgz";
    sha256 = "1sapbxg7pzi89c95k0vsp8k5bysggkjf58jwck2xs0y4ly36wbnc";
  };

  installPhase = ''
    mkdir -p $out
    cp -R * $out/
    wrapProgram $out/bin/heroku --set HEROKU_NODE_PATH ${nodejs-6_x}/bin/node
  '';

  buildInputs = [ ruby postgresql makeWrapper ];
}
