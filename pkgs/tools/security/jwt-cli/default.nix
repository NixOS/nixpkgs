{ lib, stdenv, fetchFromGitHub, rustPlatform, Security, fetchpatch }:

rustPlatform.buildRustPackage rec {
  pname = "jwt-cli";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "mike-engel";
    repo = pname;
    rev = version;
    sha256 = "sha256-82Le0kdt/fnSQwsRRYHy4Jv9rsCPGf5dIWmoZE2cPxY=";
  };

  cargoSha256 = "sha256-sCauVxc6JPJ4dBi5LOt+v9bdlRW+oF4cd/sfG5Xdv70=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  doInstallCheck = true;
  installCheckPhase = "$out/bin/jwt --version";

  meta = with lib; {
    description = "Super fast CLI tool to decode and encode JWTs";
    homepage = "https://github.com/mike-engel/jwt-cli";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ rycee ];
  };
}
