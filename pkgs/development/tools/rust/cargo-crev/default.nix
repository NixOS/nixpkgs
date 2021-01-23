{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, perl
, pkg-config
, Security
, curl
, libiconv
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-crev";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "crev-dev";
    repo = "cargo-crev";
    rev = "v${version}";
    sha256 = "sha256-qoN9pTpmXfwaJ37MqAggiPsH4cPr+nsT6NhAUOVclSw=";
  };

  cargoSha256 = "sha256-mmd9Ds37ST+OuCt506/YbdpOOJBp7WIVZBq+bQ2SR3U=";

  nativeBuildInputs = [ perl pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security libiconv curl ];

  meta = with lib; {
    description = "A cryptographically verifiable code review system for the cargo (Rust) package manager";
    homepage = "https://github.com/crev-dev/cargo-crev";
    license = with licenses; [ asl20 mit mpl20 ];
    maintainers = with maintainers; [ b4dm4n ];
  };
}
