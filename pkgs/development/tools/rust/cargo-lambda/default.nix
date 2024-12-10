{
  lib,
  cacert,
  curl,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  openssl,
  stdenv,
  CoreServices,
  Security,
  zig,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-lambda";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-E9jUlEiHyf5UR/UZxJj9LTfyAxGR/WsvRQdFdIVvLG8=";
  };

  cargoHash = "sha256-IXMkgpyYwll8NwTXRffbsSP5uFHGJe1n2RQ1Mbu+E70=";

  nativeCheckInputs = [ cacert ];

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.isDarwin [
      curl
      CoreServices
      Security
    ];

  checkFlags = [
    # Disabled because they access the network.
    "--skip=test_build_basic_extension"
    "--skip=test_build_basic_function"
    "--skip=test_build_basic_zip_extension"
    "--skip=test_build_basic_zip_function"
    "--skip=test_build_event_type_function"
    "--skip=test_build_http_feature_function"
    "--skip=test_build_http_function"
    "--skip=test_build_internal_zip_extension"
    "--skip=test_build_logs_extension"
    "--skip=test_build_telemetry_extension"
    "--skip=test_download_example"
    "--skip=test_init_subcommand"
    "--skip=test_init_subcommand_without_override"
    "--skip=test_build_example"
    "--skip=test_deploy_workspace"
  ];

  # remove date from version output to make reproducible
  postPatch = ''
    rm crates/cargo-lambda-cli/build.rs
  '';

  postInstall = ''
    wrapProgram $out/bin/cargo-lambda --prefix PATH : ${lib.makeBinPath [ zig ]}
  '';

  CARGO_LAMBDA_BUILD_INFO = "(nixpkgs)";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A Cargo subcommand to help you work with AWS Lambda";
    mainProgram = "cargo-lambda";
    homepage = "https://cargo-lambda.info";
    license = licenses.mit;
    maintainers = with maintainers; [
      taylor1791
      calavera
    ];
  };
}
