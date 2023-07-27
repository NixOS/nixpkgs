{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, bzip2
, openssl
, zstd
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "rtz";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "twitchax";
    repo = "rtz";
    rev = "v${version}";
    hash = "sha256-hxRZhUSmocHQJqrWVjT6af5zTM6KKCv4GycWlO1T6qM=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "bincode-2.0.0-rc.3" = "sha256-YCoTnIKqRObeyfTanjptTYeD9U2b2c+d4CJFWIiGckI=";
    };
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    bzip2
    openssl
    zstd
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  buildFeatures = [ "web" ];

  env = {
    # requires nightly features
    RUSTC_BOOTSTRAP = true;
  };

  meta = with lib; {
    description = "A tool to easily work with timezone lookups via a binary, a library, or a server";
    homepage = "https://github.com/twitchax/rtz";
    changelog = "https://github.com/twitchax/rtz/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
