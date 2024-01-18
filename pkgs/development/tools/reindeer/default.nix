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
  version = "unstable-2024-01-11";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = pname;
    rev = "ff28220b43defa70f8cae77d7aa139a2f6048bf3";
    sha256 = "sha256-jh0Gq29OUp7QmSd3sT9pC9OlCnyx8lHJEAEG7eBw448=";
  };

  cargoSha256 = "sha256-3F1Df66JgZnQbt1zHNOClJPb6IB7crwvCdy7YA4UIKA=";

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

