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
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "cargo-about";
    rev = version;
    sha256 = "sha256-THyVFvotR7ttGB3YyK0XPG5m4mbgHJqu1gnZFmyFDOA=";
  };

  cargoSha256 = "sha256-o9NMhkKtdlTqmOO5mVWxcuEu4U7GkTO0B3XoMrBwiwI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ zstd ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  ZSTD_SYS_USE_PKG_CONFIG = true;

  meta = with lib; {
    description = "Cargo plugin to generate list of all licenses for a crate";
    homepage = "https://github.com/EmbarkStudios/cargo-about";
    changelog = "https://github.com/EmbarkStudios/cargo-about/blob/${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ evanjs figsoda ];
  };
}
