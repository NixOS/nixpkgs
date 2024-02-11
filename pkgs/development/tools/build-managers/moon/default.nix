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
  version = "1.20.1";

  src = fetchFromGitHub {
    owner = "moonrepo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-wAY5jifyjK5jp5nlrwt/Krp96in06SnayTKx8inrf0A=";
  };

  cargoHash = "sha256-qfDw+zmhk0M3gItiB7qfgiQCBRvOYBOirJFMyNRr714=";

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
