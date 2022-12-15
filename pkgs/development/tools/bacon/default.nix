{ lib, stdenv, rustPlatform, fetchFromGitHub, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "bacon";
  version = "2.2.7";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GVwaqpczo+9bRA8VUwpLTwP+3PQ0mqM+4F1K61WKaNA=";
  };

  cargoSha256 = "sha256-mdzNbGDA93MSuZw3gYXGIuHbt36WAlf/7JcxJtkl0mk=";

  buildInputs = lib.optional stdenv.isDarwin CoreServices;

  meta = with lib; {
    description = "Background rust code checker";
    homepage = "https://github.com/Canop/bacon";
    license = licenses.agpl3Only;
    maintainers = [ maintainers.FlorianFranzen ];
  };
}
