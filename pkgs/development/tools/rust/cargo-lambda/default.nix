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
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QTFIFD04pAcNgj+ktY8WP0ScDmSy6mNlhfiXAabMlGE=";
  };

  cargoHash = "sha256-1/+bkxEpIvaJBJatqpX186MHKOdLO8Jiw8NEnyr9ctg=";

  nativeCheckInputs = [ cacert ];

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
    "--skip=test_build_zip_workspace"
    "--skip=test_download_example"
    "--skip=test_init_subcommand"
    "--skip=test_init_subcommand_without_override"
    "--skip=test_build_example"
    "--skip=test_deploy_workspace"
    "--skip=test_add_files"
    "--skip=test_consistent_hash"
    "--skip=test_create_binary_archive_from_target"
    "--skip=test_create_binary_archive_with_base_path"
    "--skip=test_zip_extension"
    "--skip=test_zip_funcion"
    "--skip=test_zip_funcion_with_files"
    "--skip=test_zip_internal_extension"
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
    description = "Cargo subcommand to help you work with AWS Lambda";
    mainProgram = "cargo-lambda";
    homepage = "https://cargo-lambda.info";
    license = licenses.mit;
    maintainers = with maintainers; [
      taylor1791
      calavera
    ];
  };
}
