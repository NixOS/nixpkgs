{ lib, rustPlatform, fetchFromGitHub, stdenv, libiconv }:
rustPlatform.buildRustPackage rec {
  pname = "cargo-about";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "cargo-about";
    rev = version;
    sha256 = "sha256-MsXNneKj2xCci1guj1TKcIrX7XByJ5/lWUmjxAsgzPY=";
  };

  cargoSha256 = "sha256-NdzgIB6uXMtGiLwOACEIeAb4iv7mYLnwRte3M/TkSMA=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description = "Cargo plugin to generate list of all licenses for a crate";
    homepage = "https://github.com/EmbarkStudios/cargo-about";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ evanjs ];
  };
}
