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
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "crev-dev";
    repo = "cargo-crev";
    rev = "v${version}";
    sha256 = "sha256-+CqWPgdPuTE9TRwQJYibRCtdyAr25sJ2sXCUEoI0VtM=";
  };

  cargoSha256 = "sha256-cBuAVU/fS2HQohjDyzrhDEsgWD5CxTrTCsQeZll90IQ=";

  nativeBuildInputs = [ perl pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security libiconv curl ];

  meta = with lib; {
    description = "A cryptographically verifiable code review system for the cargo (Rust) package manager";
    homepage = "https://github.com/crev-dev/cargo-crev";
    license = with licenses; [ asl20 mit mpl20 ];
    maintainers = with maintainers; [ b4dm4n ];
  };
}
