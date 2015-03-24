{ stdenv, fetchurl, postgresql, ruby }:

stdenv.mkDerivation rec {
  version = "3.30.3";
  name = "heroku-${version}";

  src = fetchurl {
    url = "https://s3.amazonaws.com/assets.heroku.com/heroku-client/heroku-client-${version}.tgz";
    sha256 = "0m9l04syli4ripkh37lwk0hq4silnp830ddsk3ph77iymzh2iz1f";
  };

  installPhase = ''
    mkdir -p $out
    cp -R * $out/
  '';

  buildInputs = [ ruby postgresql ];
}
