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
  version = "unstable-2024-01-12";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = pname;
    rev = "8815ee8ac5463b7004751ff8db73d7daf0b281c4";
    sha256 = "sha256-GIIvfiCzm/dpIZB1S1wCs1/VifKzvwZ+RYXVbjNDEY4=";
  };

  cargoSha256 = "sha256-iAmwxOZTW5zLhufJG5U6m2h/yXck6NvmwXd2tsvBZh8=";

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

