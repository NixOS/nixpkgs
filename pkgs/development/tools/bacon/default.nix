{ lib, stdenv, rustPlatform, fetchFromGitHub, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "bacon";
  version = "2.2.5";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KoAaECfZ8DwGN/U1HCp/4NUvTvFYiN+li3I5gNYM/oU=";
  };

  cargoSha256 = "sha256-ifUbUeqWm/gwOqzxY8lpGvW1ArZmGAy8XxAkvEfpLVQ=";

  buildInputs = lib.optional stdenv.isDarwin CoreServices;

  meta = with lib; {
    description = "Background rust code checker";
    homepage = "https://github.com/Canop/bacon";
    license = licenses.agpl3Only;
    maintainers = [ maintainers.FlorianFranzen ];
  };
}
