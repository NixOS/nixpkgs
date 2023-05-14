{ lib
, cacert
, curl
, rustPlatform
, fetchFromGitHub
, makeWrapper
, pkg-config
, openssl
, stdenv
, CoreServices
, Security
, zig
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-lambda";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-un+GQflxhMHCMH5UEeUVsYx59ryn7MR4ApooeOuhccc=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cargo-test-macro-0.1.0" = "sha256-XvTKAbP/r1BthpEM84CYZ2yfJczxqzscGkN4JXLgvfA=";
    };
  };

  nativeCheckInputs = [cacert];

  nativeBuildInputs = [ makeWrapper pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ curl CoreServices Security ];

  checkFlags = [
    # Disabled because they accesses the network.
    "--skip=test_build_basic_extension"
    "--skip=test_build_basic_function"
    "--skip=test_build_http_function"
    "--skip=test_build_logs_extension"
    "--skip=test_build_telemetry_extension"
    "--skip=test_download_example"
    "--skip=test_init_subcommand"
    "--skip=test_init_subcommand_without_override"
  ];

  # remove date from version output to make reproducible
  postPatch = ''
    rm crates/cargo-lambda-cli/build.rs
  '';

  postInstall = ''
    wrapProgram $out/bin/cargo-lambda --prefix PATH : ${lib.makeBinPath [ zig ]}
  '';

  CARGO_LAMBDA_BUILD_INFO = "(nixpkgs)";

  meta = with lib; {
    description = "A Cargo subcommand to help you work with AWS Lambda";
    homepage = "https://cargo-lambda.info";
    license = licenses.mit;
    maintainers = with maintainers; [ taylor1791 calavera ];
  };
}
