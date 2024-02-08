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
  version = "unstable-2024-02-03";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = pname;
    rev = "8dd5629ef78d359fd8d3527157b0375762f22b1e";
    sha256 = "sha256-9WmhP8CyjwohlltfmUn5m29CmBucIH+XrfVjIJX7dS8=";
  };

  cargoSha256 = "sha256-W9YA9OZu71/bSx3EwMeueVQSTExeep+UKGYCD8c4yhc=";

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

