{ lib, rustPlatform, fetchFromGitHub, rustup, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "spin-framework";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "fermyon";
    repo = "spin";
    rev = "v${version}";
    sha256 = "sha256-TPcZu+jwop3XQzdX5ulqpcYTPNEfRzVo1R/WAyAeQms=";
  };

  buildInputs = [ rustup ] ++ lib.optional stdenv.isDarwin Security;

  cargoSha256 = "sha256-taImQfb93PbQPnjhlhqzlvsSqvHy/VFfgU2qJaqbvRc=";

  meta = with lib; {
    description = "Spin is an open source framework for building and running fast, secure, and composable cloud microservices with WebAssembly";
    homepage = "https://spin.fermyon.dev/";
    license = licenses.asl20;
    maintainers = with maintainers; [ booklearner ];
    platforms = platforms.unix;
  };
}
