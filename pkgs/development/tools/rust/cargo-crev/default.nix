{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, perl
, pkg-config
, SystemConfiguration
, Security
, CoreFoundation
, curl
, libiconv
, openssl
, git
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-crev";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "crev-dev";
    repo = "cargo-crev";
    rev = "v${version}";
    sha256 = "sha256-Lt8ubK96ntcQJEnQ37nF8N4gJ8nmphwkbM6KJor13lo=";
  };

  cargoHash = "sha256-cYhzEVHpi7qMCU9fe3wxOQGX6YssJIeo4onLUBtqN6A=";

  preCheck = ''
    export HOME=$(mktemp -d)
    git config --global user.name "Nixpkgs Test"
    git config --global user.email "nobody@example.com"
  '';

  nativeBuildInputs = [ perl pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ SystemConfiguration Security CoreFoundation libiconv curl ];

  nativeCheckInputs = [ git ];

  meta = with lib; {
    description = "A cryptographically verifiable code review system for the cargo (Rust) package manager";
    homepage = "https://github.com/crev-dev/cargo-crev";
    license = with licenses; [ asl20 mit mpl20 ];
    maintainers = with maintainers; [ b4dm4n matthiasbeyer ];
  };
}
