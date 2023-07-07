{ lib
, rustPlatform
, fetchCrate
, curl
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-unused-features";
  version = "0.1.7";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-PdSR2nZbRzV2Kg2LNEpI7/Us+r8Gy6XLdUzMLei5r8c=";
  };

  cargoSha256 = "sha256-Y0U5Qzj+S7zoXWemcSfMn0YS7wCAPj+ER0jao+f2B28=";

  nativeBuildInputs = [
    curl.dev
    pkg-config
  ];

  buildInputs = [
    curl
    openssl
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    CoreFoundation
    Security
  ]);

  meta = with lib; {
    description = "A tool to find potential unused enabled feature flags and prune them";
    homepage = "https://github.com/timonpost/cargo-unused-features";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "unused-features";
  };
}
