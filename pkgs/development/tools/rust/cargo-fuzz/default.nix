{ lib, fetchFromGitHub, rustPlatform, stdenv, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-fuzz";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "rust-fuzz";
    repo = "cargo-fuzz";
    rev = version;
    sha256 = "sha256-qbeNQM3ODkstXQTbrCv8bbkwYDBU/HB+L1k66vY4494=";
  };

  cargoSha256 = "sha256-1CTwVHOG8DOObfaGK1eGn9HDM755hf7NlqheBTJcCig=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  doCheck = false;

  meta = with lib; {
    description = "Command line helpers for fuzzing";
    homepage = "https://github.com/rust-fuzz/cargo-fuzz";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ ekleog matthiasbeyer ];
  };
}
