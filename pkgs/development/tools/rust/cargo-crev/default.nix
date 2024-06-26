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
  git,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-crev";
  version = "0.25.9";

  src = fetchFromGitHub {
    owner = "crev-dev";
    repo = "cargo-crev";
    rev = "v${version}";
    sha256 = "sha256-ZevtYJ1ibSs3an3m1KJNTTquz1w6UfTiFgd1mNHFHWE=";
  };

  cargoHash = "sha256-QHhfHm2fDFR5BpSnw1wzr3dfCWDTzWNDDdRtj2qOoKE=";

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
    ++ lib.optionals stdenv.isDarwin [
      SystemConfiguration
      Security
      CoreFoundation
      libiconv
      curl
    ];

  nativeCheckInputs = [ git ];

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
