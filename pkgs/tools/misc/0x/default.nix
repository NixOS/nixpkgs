{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage {
  pname = "0x";
  version = "unstable-2022-07-11";

  src = fetchFromGitHub {
    owner = "mcy";
    repo = "0x";
    rev = "8070704b8efdd1f16bc7e01e393230f16cd8b0a6";
    hash = "sha256-NzD/j8rBfk/cpoBnkFHFqpXz58mswLZr8TUS16vlrZQ=";
  };

  cargoPatches = [ ./add-Cargo-lock.diff ];

  cargoHash = "sha256-3qaPGIbl1jF4784KGxbfBTgW/0ayxIO9Ufp9vkhIJa4=";

  meta = with lib; {
    homepage = "https://github.com/mcy/0x";
    description = "A colorful, configurable xxd";
    license = licenses.asl20;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
