{ stdenv
, lib
, fetchFromGitHub
, protobuf
, rustPlatform
, pkg-config
, openssl
, extra-cmake-modules
, fontconfig
, rust-jemalloc-sys
, testers
, turbo
, nix-update-script
, IOKit
, CoreServices
, CoreFoundation
, capnproto
}:
rustPlatform.buildRustPackage rec{
  pname = "turbo";
  version = "1.11.3";
  src = fetchFromGitHub {
    owner = "vercel";
    repo = "turbo";
    rev = "v${version}";
    hash = "sha256-hjJXbGct9ZmriKdVjB7gwfmFsV1Tv57V7DfUMFZ8Xv0=";
  };
  cargoBuildFlags = [
    "--package"
    "turbo"
  ];
  RELEASE_TURBO_CLI = "true";

  cargoHash = "sha256-bAXO4Lqv4ibo+fz3679MjNgP2MMY8TbxhG0+DRy0xcA=";

  RUSTC_BOOTSTRAP = 1;
  nativeBuildInputs = [
    pkg-config
    extra-cmake-modules
    protobuf
    capnproto
  ];
  buildInputs = [
    openssl
    fontconfig
    rust-jemalloc-sys
  ] ++ lib.optionals stdenv.isDarwin [
      IOKit
      CoreServices
      CoreFoundation
  ];

  # Browser tests time out with chromium and google-chrome
  doCheck = false;

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex" "^\d+\.\d+\.\d+$" ];
    };
    tests.version = testers.testVersion { package = turbo; };
  };

  meta = with lib; {
    description = "High-performance build system for JavaScript and TypeScript codebases";
    mainProgram = "turbo";
    homepage = "https://turbo.build/";
    maintainers = with maintainers; [ dlip ];
    license = licenses.mpl20;
  };
}
