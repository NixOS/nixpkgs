{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, zstd
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deny";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "cargo-deny";
    rev = version;
    hash = "sha256-oNo/I0GblFnOZ6+/SBn31jp+Fywlf7PIpJQnWyPn8hU=";
  };

  cargoHash = "sha256-DbC9VeJl0OObZNvMkTIp0caiBMlw2EvJ9ib1TCRlJGQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    zstd
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  # tests require internet access
  doCheck = false;

  meta = with lib; {
    description = "Cargo plugin to generate list of all licenses for a crate";
    homepage = "https://github.com/EmbarkStudios/cargo-deny";
    changelog = "https://github.com/EmbarkStudios/cargo-deny/blob/${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda matthiasbeyer jk ];
  };
}
