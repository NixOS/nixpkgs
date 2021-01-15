{ lib, stdenv, fetchFromGitHub, rustPlatform, Security, fetchpatch }:

rustPlatform.buildRustPackage rec {
  pname = "jwt-cli";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "mike-engel";
    repo = pname;
    rev = version;
    sha256 = "09zi55ffkhsckvqj84xnxn9bgfkrj9wnzqbh9hfsxzbk4xy7fc2h";
  };

  cargoSha256 = "1k13pw202fr5mvd0ys39n3dxwcl3sd01j6izfb28k06b6pav3wc8";

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
