{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, libxcb
}:
rustPlatform.buildRustPackage rec {
  pname = "magic-wormhole-rs";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "magic-wormhole";
    repo = "magic-wormhole.rs";
    rev = version;
    sha256 = "17nj0m1n90pk1r6h38ax7w8ldsh5nacml12rapa3w6v2rk6chzzq";
  };

  cargoSha256 = "0z92c8l82jizlqzl569gsknb6qqckgwnbnwv5gkf3fdaskj5n5x5";

  buildInputs = [ libxcb ];

  # all tests involve networking and are bound fail
  doCheck = false;

  meta = with lib; {
    description = "Rust implementation of Magic Wormhole, with new features and enhancements";
    homepage = "https://github.com/magic-wormhole/magic-wormhole.rs";
    license = licenses.eupl12;
    maintainers = with maintainers; [ zeri piegames ];
  };
}
