{ stdenv, fetchurl, postgresql, ruby }:

with stdenv.lib;
stdenv.mkDerivation rec {
  version = "3.32.0";
  name = "heroku-${version}";

  meta = {
    homepage = "https://toolbelt.heroku.com";
    description = "Everything you need to get started using Heroku";
    maintainers = with maintainers; [ aflatter mirdhyn ];
    license = licenses.mit;
  };

  src = fetchurl {
    url = "https://s3.amazonaws.com/assets.heroku.com/heroku-client/heroku-client-${version}.tgz";
    sha256 = "1596zmnlwshx15xiccfskm71syrlm87jf40y2x0y7wn0vfcyis5s";
  };

  installPhase = ''
    mkdir -p $out
    cp -R * $out/
  '';

  buildInputs = [ ruby postgresql ];
}
