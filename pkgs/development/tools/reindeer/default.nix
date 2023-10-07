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
  version = "unstable-2023-09-20";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = pname;
    rev = "d2946997e49e9358d520f008085cfbe235855c12";
    sha256 = "sha256-2agiaRAis6wVGbY3wj+T5RumGlKF9YaHByLwU100dlc=";
  };

  cargoSha256 = "sha256-rgXQYcqXckm1EL7OX/HtRfEdzTV09lM+YurcPYd/8FE=";

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

