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
  version = "2024.03.11.00";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "reindeer";
    rev = "refs/tags/v${version}";
    hash = "sha256-cClbSJuEs4yIjx+13GSIevZO2PWEEHVDaMEmf729keA=";
  };

  cargoHash = "sha256-TtbkzU48j3dmqRocJdY8KJz/3YHYIi3SZYM/eB9zoIg=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [ openssl ] ++ lib.optionals stdenv.isDarwin [
      libiconv
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.CoreServices
    ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version" "branch" ];
  };

  meta = with lib; {
    description = "Reindeer is a tool which takes Rust Cargo dependencies and generates Buck build rules";
    mainProgram = "reindeer";
    homepage = "https://github.com/facebookincubator/reindeer";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ nickgerace ];
  };
}

