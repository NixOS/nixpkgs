{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-careful";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "RalfJung";
    repo = "cargo-careful";
    rev = "v${version}";
    hash = "sha256-BW1Q54DlEAle4iVUXvKdz5PRhdWe736K7yo/KRKAUys=";
  };

  cargoHash = "sha256-r5dCJT0tDo+IlDpVV90eGswIKLEWuSCogiS9Qvch2tA=";

  meta = with lib; {
    description = "A tool to execute Rust code carefully, with extra checking along the way";
    homepage = "https://github.com/RalfJung/cargo-careful";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
