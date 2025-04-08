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
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "CodSpeedHQ";
    repo = "codspeed-rust";
    rev = "v${version}";
    hash = "sha256-VAl9UceVDS2XltP3G1YxNp07R+PmuJGJ8zvtxblcQLc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-QkBc8WOzcqBwmVZN/n8ySeAAd0aotzqJ9xMJB/Qgfhg=";

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
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  cargoBuildFlags = [ "-p=cargo-codspeed" ];
  cargoTestFlags = cargoBuildFlags;
  checkFlags = [
    # requires an extra dependency, blit
    "--skip=test_package_in_deps_build"
  ];

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
