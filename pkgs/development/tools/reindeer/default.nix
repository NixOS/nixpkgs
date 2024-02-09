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
  version = "unstable-2024-01-30";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = pname;
    rev = "2fe0af4d3b637d3dfff41d26623a4596a7b5fdb0";
    sha256 = "sha256-MUMqM6BZUECxdOkBdeNMEE88gJumKI/ODo+1hmmrCHY=";
  };

  cargoSha256 = "sha256-fquvUq9MjC7J24wuZR+voUkm3F7eMy1ELxMuELlQaus=";

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

