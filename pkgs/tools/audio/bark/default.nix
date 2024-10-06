{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
  cmake,
  libopus,
  soxr,
}:
let
  version = "0.6.0";
  src = fetchFromGitHub {
    owner = "haileys";
    repo = "bark";
    rev = "v${version}";
    hash = "sha256-JaUIWGCYhasM0DgqL+DiG2rE1OWVg/N66my/4RWDN1E=";
  };
in
rustPlatform.buildRustPackage {
  pname = "bark";
  inherit version src;
  # cargo.lock contains git dependencies (soxr) so we use a copied version for now.
  # Fix this post v0.6.0 when soxr is published to crates.io
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "soxr-0.0.0" = "sha256-dizttu5GhC1otLlQHU81NymC1a9cQf8hFR0oI+SPqkM=";
    };
  };

  # Broken rustdoc comment
  patches = [ ./lol.patch ];

  buildInputs = [
    alsa-lib
    libopus
    soxr
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  meta = {
    description = "Live sync audio streaming for local networks";
    homepage = "https://github.com/haileys/bark";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ samw ];
    platforms = lib.platforms.linux;
    mainProgram = "bark";
  };
}
