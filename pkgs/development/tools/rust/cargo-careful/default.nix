{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-careful";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "RalfJung";
    repo = "cargo-careful";
    rev = "v${version}";
    hash = "sha256-Yye1Dz6XTh7bWz63zENQ0QDbYbulO6SnRV7g/6mMgUw=";
  };

  cargoHash = "sha256-syj3Hf+DxPoJgNbZQERHaKAZwMYuCCmuEGb8ylQt1Xo=";

  meta = with lib; {
    description = "Tool to execute Rust code carefully, with extra checking along the way";
    mainProgram = "cargo-careful";
    homepage = "https://github.com/RalfJung/cargo-careful";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
