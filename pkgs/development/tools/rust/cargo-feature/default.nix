{ lib, rustPlatform, fetchFromGitHub, stdenv, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-feature";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "Riey";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-aUzmD5Dt0obXWDdZT6/Bzun2R1TLQYYELrN4xEG4hq8=";
  };

  cargoSha256 = "sha256-R8OaxlBAkK5YQPejOdLuCMeQlCbPcC/VQm9WHm31v54=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description = "Allows conveniently modify features of crate";
    homepage = "https://github.com/Riey/cargo-feature";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ riey ];
  };
}

