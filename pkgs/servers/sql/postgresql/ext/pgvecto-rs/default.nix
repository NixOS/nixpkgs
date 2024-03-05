{ lib
, fetchFromGitHub
, pkg-config
, nix-update-script
, nixosTests
, buildPgrxExtension
, postgresql
, rustPlatform
, substituteAll
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

  patches = [
    (substituteAll {
      src = ./read-clang-flags-from-environment.patch;
      clang = lib.getExe clang_16;
    })
  ];

  # Set appropriate version on vectors.control, otherwise it won't show up on PostgreSQL
  postPatch = ''
    substituteInPlace vectors.control --subst-var-by CARGO_VERSION ${version}
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "openai_api_rust-0.1.8" = "sha256-os5Y8KIWXJEYEcNzzT57wFPpEXdZ2Uy9W3j5+hJhhR4=";
      "std_detect-0.1.5" = "sha256-RwWejfqyGOaeU9zWM4fbb/hiO1wMpxYPKEjLO0rtRmU=";
    };
  };

  env = {
    # Needed to get openssl-sys to use pkg-config.
    OPENSSL_NO_VENDOR = 1;

    # Bypass rust nightly features not being available on rust stable
    RUSTC_BOOTSTRAP = 1;
  };

  # Include upgrade scripts in the final package
  # https://github.com/tensorchord/pgvecto.rs/blob/v0.2.1/scripts/build_2.sh#L19
  postInstall = ''
    cp sql/upgrade/* $out/share/postgresql/extension/
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      pgvecto-rs = nixosTests.pgvecto-rs;
    };
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
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
