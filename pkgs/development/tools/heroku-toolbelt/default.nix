{ stdenv, fetchurl, ruby }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "heroku-toolbelt-3.28.2";

  src = fetchurl {
    url = "https://s3.amazonaws.com/assets.heroku.com/heroku-client/heroku-client.tgz";
    sha256 = "adad5df72dcaf19f4c1ffa6fdba483fd0cf2b5d74bd43cfa870afb44709a3ab0";
  };

  buildInputs = [ ruby ];

    installPhase = '' 
      mkdir -p $out
      cp -prvd * $out/
    '';

  meta = {
    homepage = "https://toolbelt.heroku.com";
    description = "Everything you need to get started using Heroku";
    maintainers = with maintainers; [ mirdhyn ];
    license = licenses.mit;
  };
}