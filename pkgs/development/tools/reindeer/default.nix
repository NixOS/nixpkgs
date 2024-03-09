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
  version = "unstable-2024-03-06";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = pname;
    rev = "3ec771e9608a01c90d6aac92aa77145551786c64";
    sha256 = "sha256-cClbSJuEs4yIjx+13GSIevZO2PWEEHVDaMEmf729keA=";
  };

  cargoSha256 = "sha256-plkn+snWUaOH6ZxaPUbCvnNOky+eL6oY4ZHwv+qyNiE=";

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
    homepage = "https://github.com/facebookincubator/reindeer";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ nickgerace ];
  };
}

