{
  lib,
  fetchFromGitHub,
  nixosTests,
  rustPlatform,
  stdenv,
  installShellFiles,
  cmake,
  libsodium,
  pkg-config,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rosenpass";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "rosenpass";
    repo = "rosenpass";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fQIeKGyTkFWUV9M1o256G4U1Os5OlVsRZu+5olEkbD4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-vx6kSdDOXiIp2626yKVieDuS9DD5/wKyXutMiKMKn24=";

  nativeBuildInputs = [
    cmake # for oqs build in the oqs-sys crate
    pkg-config
    rustPlatform.bindgenHook # for C-bindings in the crypto libs
    installShellFiles
  ];

  buildInputs = [ libsodium ];

  # nix defaults to building for aarch64 _without_ the armv8-a
  # crypto extensions, but liboqs depends on these
  preBuild = lib.optionalString stdenv.hostPlatform.isAarch64 ''
    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -march=armv8-a+crypto"
  '';

  postInstall = ''
    installManPage doc/rosenpass.1
  '';

  passthru = {
    tests = { inherit (nixosTests) rosenpass; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Build post-quantum-secure VPNs with WireGuard";
    homepage = "https://rosenpass.eu/";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [ wucke13 ];
    teams = with lib.teams; [ ngi ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    mainProgram = "rosenpass";
  };
})
