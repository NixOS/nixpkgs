{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "flip-link";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "knurling-rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-LE0cWS6sOb9/VvGloezNnePHGldnpfNTdCFUv3F/nwE=";
  };

  cargoSha256 = "sha256-8WBMF5stMB4JXvYwa5yHVFV+3utDuMFJNTZ4fZFDftw=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description = "Adds zero-cost stack overflow protection to your embedded programs";
    homepage = "https://github.com/knurling-rs/flip-link";
    license = with licenses; [ asl20 mit ];
    maintainers = [ maintainers.FlorianFranzen ];
  };
}
