{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "moon";
  version = "1.34.3";

  src = fetchFromGitHub {
    owner = "moonrepo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-LLKHRybTSUhz5YfaV7scVASa6TJqkHDbpVfzL2bANtQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Rx6g+J7Sh1G8ZrUP55oxrUwCyBp0WV67yG6+ql9J5QI=";

  env = {
    RUSTFLAGS = "-C strip=symbols";
    OPENSSL_NO_VENDOR = 1;
  };

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  # Some tests fail, because test using internet connection and install NodeJS by example
  doCheck = false;

  meta = with lib; {
    description = "Task runner and repo management tool for the web ecosystem, written in Rust";
    mainProgram = "moon";
    homepage = "https://github.com/moonrepo/moon";
    license = licenses.mit;
    maintainers = with maintainers; [ flemzord ];
  };
}
