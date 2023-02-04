{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, openssl
, pkg-config
, AppKit
, Cocoa
, Foundation
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "iay";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "aaqaishtyaq";
    repo = pname;
    rev = "v${version}";
    sha256 = "0r2yp34gxkh32amrysfj1jg543dh0kyqxzcx0zyi6a8y9232d8ky";
  };

  cargoHash = "sha256-SMqiwM6LrXXjV4Mb2BY9WbeKKPkxiYxPyZ4aepVIAqU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.isDarwin [
    AppKit
    Cocoa
    Foundation
    Security
  ];

  NIX_LDFLAGS = lib.optionals stdenv.isDarwin [ "-framework" "AppKit" ];

  meta = with lib; {
    description = "Minimalistic, blazing-fast, and extendable prompt for bash and zsh";
    homepage = "https://github.com/aaqaishtyaq/iay";
    license = licenses.mit;
    maintainers = with maintainers; [ aaqaishtyaq omasanori ];
  };
}
