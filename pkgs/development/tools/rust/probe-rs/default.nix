{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libusb1,
  openssl,
  DarwinTools,
  AppKit,
}:

rustPlatform.buildRustPackage rec {
  pname = "probe-rs";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5V7eLnukVAcOSX52myvaTlDbemGp6mDaWrQc3w4P5MI=";
  };

  cargoHash = "sha256-sZl4FhaKIMJe7v5AAIM2w7M8Ev7vCht3owkvt0UhOu8=";

  cargoBuildFlags = [ "--features=cli" ];

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.isDarwin [ DarwinTools ];

  buildInputs = [
    libusb1
    openssl
  ] ++ lib.optionals stdenv.isDarwin [ AppKit ];

  meta = with lib; {
    description = "CLI tool for on-chip debugging and flashing of ARM chips";
    homepage = "https://probe.rs/";
    changelog = "https://github.com/probe-rs/probe-rs/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      xgroleau
      newam
    ];
  };
}
