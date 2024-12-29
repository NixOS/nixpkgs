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
  pname = "turbo-unwrapped";
  version = "1.13.2";
  src = fetchFromGitHub {
    owner = "vercel";
    repo = "turbo";
    rev = "v${version}";
    hash = "sha256-q1BxBAjfHyGDaH/IywPw9qnZJjzeU4tu2CyUWbnd6y8=";
  };
  cargoBuildFlags = [
    "--package"
    "turbo"
  ];
  RELEASE_TURBO_CLI = "true";

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes."tui-term-0.1.8" = "sha256-MNeVnF141uNWbjqXEbHwXnMTkCnvIteb5v40HpEK6D4=";
  };

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
