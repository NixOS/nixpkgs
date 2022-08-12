{ lib, stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-feature-set";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = "cargo-feature-set";
    rev = "v${version}";
    sha256 = "sha256-hKdH+vWtigKtD1rgnOEEULZ9dxh/U/QALmocxOJdEG4=";
  };

  cargoSha256 = "sha256-J7iJ//9q785jGaL143jxbhvr8UWBk7NN8S3Hh65dieA=";

  meta = with lib; {
    description = "Extract the features for every compiled crate from cargo metadata";
    homepage = "https://github.com/badboy/cargo-feature-set";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

