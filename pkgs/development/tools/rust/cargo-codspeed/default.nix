{
  lib,
  rustPlatform,
  fetchFromGitHub,
  curl,
  pkg-config,
  libgit2,
  openssl,
  zlib,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-codspeed";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "CodSpeedHQ";
    repo = "codspeed-rust";
    rev = "v${version}";
    hash = "sha256-pi02Bn5m4JoTtCIZvxkiUVKkjmtCShKqZw+AyhaVdyY=";
  };

  cargoHash = "sha256-5Ps31Hdis+N/MT/o0IDHSJgHBM3F/ve50ovfFSviMtA=";

  nativeBuildInputs = [
    curl
    pkg-config
  ];

  buildInputs =
    [
      curl
      libgit2
      openssl
      zlib
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  cargoBuildFlags = [ "-p=cargo-codspeed" ];
  cargoTestFlags = cargoBuildFlags;

  env = {
    LIBGIT2_NO_VENDOR = 1;
  };

  meta = with lib; {
    description = "Cargo extension to build & run your codspeed benchmarks";
    homepage = "https://github.com/CodSpeedHQ/codspeed-rust";
    changelog = "https://github.com/CodSpeedHQ/codspeed-rust/releases/tag/${src.rev}";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "cargo-codspeed";
  };
}
