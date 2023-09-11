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
  version = "unstable-2023-08-14";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = pname;
    rev = "7ab6fc86006c3a9c7d46775d23474f86b1d29881";
    sha256 = "sha256-wn5MwBDOKnHIOVYZK68GOjvX7dkFaWJuLJOxgUR6bok=";
  };

  cargoSha256 = "sha256-MVQVYiJ6512wahVG8ONtZB+jgXXEGGFnE89VHGa/77U=";

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

