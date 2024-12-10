{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-info";
  version = "0.7.6";

  src = fetchFromGitLab {
    owner = "imp";
    repo = "cargo-info";
    rev = version;
    hash = "sha256-02Zkp7Vc1M5iZsG4iJL30S73T2HHg3lqrPJ9mW3FOuk=";
  };

  cargoHash = "sha256-zp7qklME28HNGomAcQgrEi7W6zQ1QCJc4FjxtnKySUE=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  meta = with lib; {
    description = "Cargo subcommand to show crates info from crates.io";
    mainProgram = "cargo-info";
    homepage = "https://gitlab.com/imp/cargo-info";
    changelog = "https://gitlab.com/imp/cargo-info/-/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [
      figsoda
      matthiasbeyer
    ];
  };
}
