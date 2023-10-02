{ lib
, rustPlatform
, fetchFromGitHub
, curl
, pkg-config
, libgit2_1_5
, openssl
, zlib
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-codspeed";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "CodSpeedHQ";
    repo = "codspeed-rust";
    rev = "v${version}";
    hash = "sha256-AGbo38weLBPxkaXgJpi+FXGuhPh7nyZcJOhw6BCDYOc=";
  };

  cargoHash = "sha256-NR+Z5oMaReEOZrLk7d/pB1F37k8tE7FXh4HdVnh+YFc=";

  nativeBuildInputs = [
    curl
    pkg-config
  ];

  buildInputs = [
    curl
    libgit2_1_5
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.Security
  ];

  cargoBuildFlags = [ "-p=cargo-codspeed" ];
  cargoTestFlags = cargoBuildFlags;

  meta = with lib; {
    description = "Cargo extension to build & run your codspeed benchmarks";
    homepage = "https://github.com/CodSpeedHQ/codspeed-rust";
    changelog = "https://github.com/CodSpeedHQ/codspeed-rust/releases/tag/${src.rev}";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "cargo-codspeed";
  };
}
