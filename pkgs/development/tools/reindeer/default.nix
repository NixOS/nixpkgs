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
  version = "2024.06.24.00";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "reindeer";
    rev = "refs/tags/v${version}";
    hash = "sha256-J3ZrlX83TE63Go4qp+lMhexkuaV0ZgHNYga8qxZF0wI=";
  };

  cargoHash = "sha256-oPo5fmf45FJEoeAXQSZ4+uhKN4CSwhe8AbdPV4ehGd4=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [ openssl ] ++ lib.optionals stdenv.isDarwin [
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

