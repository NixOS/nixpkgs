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
  version = "1.22.4";

  src = fetchFromGitHub {
    owner = "moonrepo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Hx31oEvf6irURxtLBPaY2unCgW0tBurhSjhBNI1ifng=";
  };

  cargoHash = "sha256-DKktU8w+4TeGSzidjovK9xgis98Gz7BretrO+bpfnTc=";

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
