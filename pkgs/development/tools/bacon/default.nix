{ lib, stdenv, rustPlatform, fetchFromGitHub, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "bacon";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9HyGHj1JWZ2S7XZCj69VdzlG4nwgzr1BKW4+4f+L+yM=";
  };

  cargoSha256 = "sha256-DlBOZUdIg7yqLeLWqiiOFb+NSeTYJUl0RIJRG35oV4M=";

  buildInputs = lib.optional stdenv.isDarwin CoreServices;

  meta = with lib; {
    description = "Background rust code checker";
    homepage = "https://github.com/Canop/bacon";
    license = licenses.agpl3Only;
    maintainers = [ maintainers.FlorianFranzen ];
  };
}
