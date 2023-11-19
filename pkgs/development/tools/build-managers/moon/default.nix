{ lib
, rustPlatform
, fetchFromGitHub
, darwin
, stdenv
, openssl
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "moon";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "moonrepo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-FPhUGFumbO28rPWNDTrUNqMx0ppbotp9z6u8cCEHu/g=";
  };

  cargoHash = "sha256-hak0xMV6MSqM88bNY+2C5B5YlRWlZ+dDYu50pYEDsmI=";

  env = {
    RUSTFLAGS = "-C strip=symbols";
    OPENSSL_NO_VENDOR = 1;
  };

  buildInputs = [ openssl ] ++
    lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
  ];
  nativeBuildInputs = [ pkg-config ];

  # Some tests fail, because test using internet connection and install NodeJS by example
  doCheck = false;

  meta = with lib; {
    description = "A task runner and repo management tool for the web ecosystem, written in Rust";
    homepage = "https://github.com/moonrepo/moon";
    license = licenses.mit;
    maintainers = with maintainers; [ flemzord ];
  };
}
