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
  version = "0.24.3";

  src = fetchFromGitHub {
    owner = "crev-dev";
    repo = "cargo-crev";
    rev = "v${version}";
    sha256 = "sha256-CCTG58dwO9gYe0WSUXFeaBSgvZ7pbX9S3B3hzabzkjo=";
  };

  cargoHash = "sha256-p2qAWAZ1Y0GI0t9wHmn5Ww3o5vXpA6rsA/D7HD2x6o0=";

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
