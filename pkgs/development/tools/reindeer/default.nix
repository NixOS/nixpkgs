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
  version = "unstable-2024-02-15";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = pname;
    rev = "a34b75c4d2840f475a5f30b041b0d478bc3f8cce";
    sha256 = "sha256-avY1fXkuP4f8iuoUklcrPb4DpfyftW0FIk6zVUCdBwI=";
  };

  cargoSha256 = "sha256-RSmj0Xf55kEPi5EJ72pe0tagQBkUVf7isvsu7ATzsUk=";

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

