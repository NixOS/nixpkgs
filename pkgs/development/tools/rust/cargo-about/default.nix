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
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "cargo-about";
    rev = version;
    sha256 = "sha256-T8Hhody0jMmZb6/xMkSvKCv4STZPbcrf/UB3APspYDM=";
  };

  cargoPatches = [
    # update mimalloc to fix build with older apple sdks
    ./update-mimalloc.patch

    # enable pkg-config feature of zstd
    ./zstd-pkg-config.patch
  ];

  cargoSha256 = "sha256-2Reqj+WP6OoaB/3Z5llZP4c5ToVmMNX0Fe0IqDwcg2E=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ zstd ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Cargo plugin to generate list of all licenses for a crate";
    homepage = "https://github.com/EmbarkStudios/cargo-about";
    changelog = "https://github.com/EmbarkStudios/cargo-about/blob/${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ evanjs figsoda ];
  };
}
