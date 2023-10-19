{ lib
, rustPlatform
, fetchCrate
, curl
, pkg-config
, libgit2_1_5
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-unused-features";
  version = "0.2.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-gdwIbbQDw/DgBV9zY2Rk/oWjPv1SS/+oFnocsMo2Axo=";
  };

  cargoHash = "sha256-K9I7Eg43BS2SKq5zZ3eZrMkmuHAx09OX240sH0eGs+k=";

  nativeBuildInputs = [
    curl.dev
    pkg-config
  ];

  buildInputs = [
    curl
    libgit2_1_5
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "A tool to find potential unused enabled feature flags and prune them";
    homepage = "https://github.com/timonpost/cargo-unused-features";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
    mainProgram = "unused-features";
  };
}
