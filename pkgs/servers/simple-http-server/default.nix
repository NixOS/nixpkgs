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
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "TheWaWaR";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QVNHomav8k1HflrOoQ7Ub5ZSCExpikbe0iAaVlAJEEs=";
  };

  cargoHash = "sha256-uDdzv0uPITE4DySoHPMFkJ0/wrPNZOao43Z7tOhRboI=";

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
    mainProgram = "simple-http-server";
  };
}
