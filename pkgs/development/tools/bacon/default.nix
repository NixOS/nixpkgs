{ lib, stdenv, rustPlatform, fetchFromGitHub, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "bacon";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0/fQhBHkoI/0PhuUDLGfyjytgEEJWSr1P67Rh0vGDnA=";
  };

  cargoSha256 = "sha256-O1jJXnvPLxJmcnf3qpdcpdrogQ7FtjHF8uUxQRWLDyg=";

  buildInputs = lib.optional stdenv.isDarwin CoreServices;

  meta = with lib; {
    description = "Background rust code checker";
    homepage = "https://github.com/Canop/bacon";
    license = licenses.agpl3Only;
    maintainers = [ maintainers.FlorianFranzen ];
  };
}
