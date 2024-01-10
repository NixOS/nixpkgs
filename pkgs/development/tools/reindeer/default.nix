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
  version = "unstable-2023-12-21";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = pname;
    rev = "ef28c77b630c371971f624d14597eacbf90d23f9";
    sha256 = "sha256-6okyRF9y2vjBye2Jbdwx1slyhP6y7syEvwnvLXwQlok=";
  };

  cargoSha256 = "sha256-1QCjNIwS9/kQyq5CIqOa+wdKbH6pkZ0Wg5rHaGuZ/nI=";

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

