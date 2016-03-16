{ stdenv, fetchurl, postgresql, ruby, makeWrapper, nodejs-5_x }:

with stdenv.lib;
stdenv.mkDerivation rec {
  version = "3.42.20";
  name = "heroku-${version}";

  meta = {
    homepage = "https://toolbelt.heroku.com";
    description = "Everything you need to get started using Heroku";
    maintainers = with maintainers; [ aflatter mirdhyn ];
    license = licenses.mit;
  };

  src = fetchurl {
    url = "https://s3.amazonaws.com/assets.heroku.com/heroku-client/heroku-client-${version}.tgz";
    sha256 = "1d472vm37lx5nyyaymjglavisb1mkyzbjglzjp5im7wjfifvsd29";
  };

  installPhase = ''
    mkdir -p $out
    cp -R * $out/
    wrapProgram $out/bin/heroku --set HEROKU_NODE_PATH ${nodejs-5_x}/bin/node
  '';

  buildInputs = [ ruby postgresql makeWrapper ];
}
