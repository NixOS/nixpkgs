{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2_1_5
, openssl
, zlib
, zstd
, stdenv
, curl
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deny";
  version = "0.13.8";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = pname;
    rev = version;
    hash = "sha256-6RmC54DsL31/SBrA16p+iub7VTQvc1nG+ml+6Xaj0NM=";
  };

  cargoHash = "sha256-u3hv1phSwZ4oILFMWIAqWhdt0jI8ao3gje1WZA3ZFo8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2_1_5
    openssl
    zlib
    zstd
  ] ++ lib.optionals stdenv.isDarwin [
    curl
    darwin.apple_sdk.frameworks.Security
  ];

  buildNoDefaultFeatures = true;

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
