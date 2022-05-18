{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "spin-framework";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "fermyon";
    repo = "spin";
    rev = "v${version}";
    sha256 = "sha256-ilRjwBssSKwYEouhCxcryygzBDA+W1X9jGySAFL+EfU=";
  };

  cargoSha256 = lib.fakeSha256;

  meta = with lib; {
    description = "Spin is an open source framework for building and running fast, secure, and composable cloud microservices with WebAssembly";
    homepage = "https://spin.fermyon.dev/";
    license = licenses.asl20;
    maintainers = with maintainers; [ booklearner ];
    platforms = platforms.unix;
  };
}
