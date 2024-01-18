{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, zstd
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-about";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "cargo-about";
    rev = version;
    sha256 = "sha256-srJ5NyO+kySFCcqyF0i99Zvh2XsNAyFvTUcks/kt0qs=";
  };

  cargoHash = "sha256-eO4dBXVBjuN68cTvw8LzzJEedu5+dizOMu4QFEOzKK8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ zstd ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = with lib; {
    description = "Cargo plugin to generate list of all licenses for a crate";
    homepage = "https://github.com/EmbarkStudios/cargo-about";
    changelog = "https://github.com/EmbarkStudios/cargo-about/blob/${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ evanjs figsoda matthiasbeyer ];
    mainProgram = "cargo-about";
  };
}
