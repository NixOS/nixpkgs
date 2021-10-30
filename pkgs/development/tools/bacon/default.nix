{ lib, stdenv, rustPlatform, fetchFromGitHub, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "bacon";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pcwu6UJr8pgTVXMefXCtET2DFaNIixmwCUYlv1GF8Ck=";
  };

  cargoSha256 = "sha256-zpVnF1InSVEZfhch7g5w2WgFYXwp9xVjEV3gvwx+Ndo=";

  buildInputs = lib.optional stdenv.isDarwin CoreServices;

  meta = with lib; {
    description = "Background rust code checker";
    homepage = "https://github.com/Canop/bacon";
    license = licenses.agpl3Only;
    maintainers = [ maintainers.FlorianFranzen ];
  };
}
