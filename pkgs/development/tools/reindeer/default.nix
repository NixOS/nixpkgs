{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, libiconv
, darwin
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "reindeer";
  version = "2024.09.30.00";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "reindeer";
    rev = "refs/tags/v${version}";
    hash = "sha256-MGOT9fG5scZzHZ1mgqBE3GfhOnTRyPjD2kibbCteUjc=";
  };

  cargoHash = "sha256-es2jdfVSufXdUxHbQ4MYPPmsnnxT7DTcoCi10YhW/7I=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [ openssl ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.CoreServices
    ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Reindeer is a tool which takes Rust Cargo dependencies and generates Buck build rules";
    mainProgram = "reindeer";
    homepage = "https://github.com/facebookincubator/reindeer";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ nickgerace ];
  };
}

