{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  perl,
  pkg-config,
  SystemConfiguration,
  Security,
  CoreFoundation,
  curl,
  libiconv,
  openssl,
  gitMinimal,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-crev";
  version = "0.26.3";

  src = fetchFromGitHub {
    owner = "crev-dev";
    repo = "cargo-crev";
    rev = "v${version}";
    sha256 = "sha256-OxE0+KK2qt06gAi7rw3hiG2lczBqbyNThb4aCpyM6q8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-MdRK4mQ09KatcgjTu/0l6Qkd3FYefiwC+UcmXOgsQ0A=";

  preCheck = ''
    export HOME=$(mktemp -d)
    git config --global user.name "Nixpkgs Test"
    git config --global user.email "nobody@example.com"
  '';

  nativeBuildInputs = [
    perl
    pkg-config
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      SystemConfiguration
      Security
      CoreFoundation
      libiconv
      curl
    ];

  nativeCheckInputs = [ gitMinimal ];

  meta = with lib; {
    description = "Cryptographically verifiable code review system for the cargo (Rust) package manager";
    mainProgram = "cargo-crev";
    homepage = "https://github.com/crev-dev/cargo-crev";
    license = with licenses; [
      asl20
      mit
      mpl20
    ];
    maintainers = with maintainers; [
      b4dm4n
      matthiasbeyer
    ];
  };
}
