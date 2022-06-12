{ lib, fetchFromGitHub, rustPlatform, stdenv, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-fuzz";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "rust-fuzz";
    repo = "cargo-fuzz";
    rev = "v${version}";
    sha256 = "sha256-vjKo0L7sYrC7qWdOGSJDWpL04tmNjO3QRwAIRHN/DiI=";
  };

  cargoSha256 = "sha256-8XVRMwrBEJ1duQtXzNpuN5wJPUgziJlka4n/nAIqeEc=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  doCheck = false;

  meta = with lib; {
    description = "Command line helpers for fuzzing";
    homepage = "https://github.com/rust-fuzz/cargo-fuzz";
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.ekleog ];
  };
}
