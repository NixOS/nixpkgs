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
  version = "unstable-2023-06-20";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = pname;
    rev = "43a317cad6e7205bd4aee067539bf613971a5624";
    sha256 = "sha256-y2/tQR8kYLpBwhow59F9pvyh/pgZ0fAGYd5zow2N1Es=";
  };

  cargoSha256 = "sha256-mzQHEtKEiP/COHgeZnRN1CfFPcK+RaD7WuvWJO0OJHs=";

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

