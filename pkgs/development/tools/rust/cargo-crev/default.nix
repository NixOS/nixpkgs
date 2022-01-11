{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, perl
, pkg-config
, SystemConfiguration
, Security
, curl
, libiconv
, openssl
, git
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-crev";
  version = "0.21.3";

  src = fetchFromGitHub {
    owner = "crev-dev";
    repo = "cargo-crev";
    rev = "v${version}";
    sha256 = "sha256-CwECZz+qS5+rgwudRutcKZsYxfMLcVbA/9SZASmF+k4=";
  };

  cargoSha256 = "sha256-7c6Hu6UacQuRsCHlGKr1TtN+XHVGr1sw+HEGWeT9SJA=";

  preCheck = ''
    export HOME=$(mktemp -d)
    git config --global user.name "Nixpkgs Test"
    git config --global user.email "nobody@example.com"
  '';

  nativeBuildInputs = [ perl pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ SystemConfiguration Security libiconv curl ];

  checkInputs = [ git ];

  meta = with lib; {
    description = "A cryptographically verifiable code review system for the cargo (Rust) package manager";
    homepage = "https://github.com/crev-dev/cargo-crev";
    license = with licenses; [ asl20 mit mpl20 ];
    maintainers = with maintainers; [ b4dm4n ];
  };
}
