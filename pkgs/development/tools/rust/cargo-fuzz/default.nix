{ lib, fetchFromGitHub, rustPlatform, stdenv, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-fuzz";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "rust-fuzz";
    repo = "cargo-fuzz";
    rev = version;
    sha256 = "sha256-itChRuBl5n6lo/d7F5pVth5EbtWPleBcE8ReErmfv9M=";
  };

  cargoHash = "sha256-AWtycqlmCPISfgX47DXOE6l3jPM1gng9ALTiF87NozI=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  doCheck = false;

  meta = with lib; {
    description = "Command line helpers for fuzzing";
    homepage = "https://github.com/rust-fuzz/cargo-fuzz";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ ekleog matthiasbeyer ];
  };
}
