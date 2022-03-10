{ lib, rustPlatform, fetchFromGitHub, pkg-config, zstd, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-about";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "cargo-about";
    rev = version;
    sha256 = "sha256-KrUb71/wEQnAD2VVkufw12kXrz35sU5fNciSJsMyGrc=";
  };

  # enable pkg-config feature of zstd
  cargoPatches = [ ./zstd-pkg-config.patch ];

  cargoSha256 = "sha256-JewI+23eNrMHfSUwsA3CaeTvG61/ZOFFLpm7rKZKsoU=";

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
