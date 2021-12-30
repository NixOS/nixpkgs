{ lib, fetchFromGitHub, rustPlatform, stdenv, libiconv, cargo-fuzz, testVersion }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-fuzz";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "rust-fuzz";
    repo = "cargo-fuzz";
    rev = version;
    sha256 = "sha256-5dHEUGn2CrEpSTJsbnSRx/hKXx6dLCDcuD1dPOH49d4=";
  };

  cargoSha256 = "sha256-vZPd8Zzyp0PgIdyp5qY57ex0cCihplw/FY+xf3etuu8=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  doCheck = false;

  passthru.tests.version = testVersion { package = cargo-fuzz; };

  meta = with lib; {
    description = "Command line helpers for fuzzing";
    homepage = "https://github.com/rust-fuzz/cargo-fuzz";
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.ekleog ];
  };
}
