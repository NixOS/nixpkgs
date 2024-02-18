{ lib
, fetchFromGitHub
, pkg-config
, nix-update-script
, nixosTests
, buildPgrxExtension
, postgresql
, rustPlatform
, clang_16
, openssl
}:

buildPgrxExtension rec {
  inherit postgresql;

  pname = "pgvecto-rs";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "tensorchord";
    repo = "pgvecto.rs";
    rev = "v${version}";
    hash = "sha256-kwaGHerEVh6Oxb9jQupSapm7CsKl5CoH6jCv+zbi4FE=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "openai_api_rust-0.1.8" = "sha256-os5Y8KIWXJEYEcNzzT57wFPpEXdZ2Uy9W3j5+hJhhR4=";
      "std_detect-0.1.5" = "sha256-RwWejfqyGOaeU9zWM4fbb/hiO1wMpxYPKEjLO0rtRmU=";
    };
  };

  # Bypass rust nightly features not being available on rust stable
  RUSTC_BOOTSTRAP = 1;
  patches = [ ./0001-pgvecto.rs-zeroed-uninit.patch ];

  # Needed to get openssl-sys to use pkg-config.
  env.OPENSSL_NO_VENDOR = 1;

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      pgvecto-rs = nixosTests.pgvecto-rs;
    };
  };

  # pgvecto.rs requires clang 16 to be built.
  postPatch = ''
    substituteInPlace crates/c/build.rs \
      --replace '"clang-16"' '"${lib.getExe clang_16}"'
  '';

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    pkg-config
  ];
  buildInputs = [
    postgresql
    openssl
  ];

  meta = with lib; {
    description = "Scalable Vector database plugin for Postgres, written in Rust, specifically designed for LLM";
    homepage = "https://github.com/tensorchord/pgvecto.rs";
    maintainers = with maintainers; [ esclear ];
    platforms = [ "x86_64-linux" ];
    license = licenses.asl20;
  };
}
