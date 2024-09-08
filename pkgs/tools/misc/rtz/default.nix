{ lib
, rustPlatform
, fetchFromGitHub
, fetchurl
, pkg-config
, bzip2
, openssl
, zstd
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "rtz";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "twitchax";
    repo = "rtz";
    rev = "v${version}";
    hash = "sha256-Wfb3FEZHjWYUtRI4Qn3QNunIXuzW1AIEZkIvtVrjBPs=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "bincode-2.0.0-rc.3" = "sha256-YCoTnIKqRObeyfTanjptTYeD9U2b2c+d4CJFWIiGckI=";
    };
  };

  swagger-ui = fetchurl {
    url = "https://github.com/juhaku/utoipa/raw/master/utoipa-swagger-ui-vendored/res/v5.17.12.zip";
    hash = "sha256-HK4z/JI+1yq8BTBJveYXv9bpN/sXru7bn/8g5mf2B/I=";
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
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  buildFeatures = [ "web" ];

  # ${swagger-ui} is read-only and the copy made by the build script
  # is as well. Remove it so that checks can copy it again.
  preCheck = ''
    find target -name $(basename ${swagger-ui}) -delete
  '';

  env = {
    # use local data file instead of requiring network access
    SWAGGER_UI_DOWNLOAD_URL = "file://${swagger-ui}";
  };

  meta = with lib; {
    description = "Tool to easily work with timezone lookups via a binary, a library, or a server";
    homepage = "https://github.com/twitchax/rtz";
    changelog = "https://github.com/twitchax/rtz/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "rtz";
  };
}
