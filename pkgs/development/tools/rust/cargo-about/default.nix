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
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "cargo-about";
    rev = version;
    sha256 = "sha256-OAKTEU4+m9QMW/EMhCrN5HTMSjnPzEU0ISCeauI76SY=";
  };

  cargoSha256 = "sha256-BGopHg4giLVie+z7kjlb9rTvLTovFyJ/emCF4j0Va04=";

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
