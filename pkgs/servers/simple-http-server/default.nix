{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "simple-http-server";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "TheWaWaR";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-b+z3rio+kg1Z0B4pqhTlCTtzXgAeCAhinSa9dkIwcaY=";
  };

  cargoSha256 = "sha256-teBqgQloI/13F7K/+EBKFcHWqcK1wJrNUu5LO8nwQbo=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  # Currently no tests are implemented, so we avoid building the package twice
  doCheck = false;

  meta = with lib; {
    description = "Simple HTTP server in Rust";
    homepage = "https://github.com/TheWaWaR/simple-http-server";
    changelog = "https://github.com/TheWaWaR/simple-http-server/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda mephistophiles ];
  };
}
