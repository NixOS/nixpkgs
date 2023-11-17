{ lib
, fetchFromGitHub
, nixosTests
, rustPlatform
, hostPlatform
, installShellFiles
, cmake
, libsodium
, pkg-config
}:
rustPlatform.buildRustPackage rec {
  pname = "rosenpass";
  version = "unstable-2023-09-28";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "b15f17133f8b5c3c5175b4cfd4fc10039a4e203f";
    hash = "sha256-UXAkmt4VY0irLK2k4t6SW+SEodFE3CbX5cFbsPG0ZCo=";
  };

  cargoHash = "sha256-N1DQHkgKgkDQ6DbgQJlpZkZ7AMTqX3P8R/cWr14jK2I=";

  nativeBuildInputs = [
    cmake # for oqs build in the oqs-sys crate
    pkg-config
    rustPlatform.bindgenHook # for C-bindings in the crypto libs
    installShellFiles
  ];

  buildInputs = [ libsodium ];

  # nix defaults to building for aarch64 _without_ the armv8-a
  # crypto extensions, but liboqs depends on these
  preBuild = lib.optionalString hostPlatform.isAarch64 ''
    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -march=armv8-a+crypto"
  '';

  postInstall = ''
    installManPage doc/rosenpass.1
  '';

  passthru.tests.rosenpass = nixosTests.rosenpass;

  meta = with lib; {
    description = "Build post-quantum-secure VPNs with WireGuard!";
    homepage = "https://rosenpass.eu/";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ wucke13 ];
    platforms = [ "aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux" ];
    mainProgram = "rosenpass";
  };
}
