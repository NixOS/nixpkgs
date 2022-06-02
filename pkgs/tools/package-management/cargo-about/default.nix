{ lib, rustPlatform, fetchFromGitHub, pkg-config, zstd, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-about";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "cargo-about";
    rev = version;
    sha256 = "sha256-T8Hhody0jMmZb6/xMkSvKCv4STZPbcrf/UB3APspYDM=";
  };

  # enable pkg-config feature of zstd
  cargoPatches = [ ./zstd-pkg-config.patch ];

  cargoSha256 = "sha256-x/HzDYNy0FDxJmhjSUUEiyahM7Sw27aC+ULP/Ii0X/8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ zstd ];

  meta = with lib; {
    description = "Cargo plugin to generate list of all licenses for a crate";
    homepage = "https://github.com/EmbarkStudios/cargo-about";
    changelog = "https://github.com/EmbarkStudios/cargo-about/blob/${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ evanjs figsoda ];
    broken = stdenv.isDarwin;
  };
}
