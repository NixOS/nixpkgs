{ lib, rustPlatform, fetchFromGitHub, pkg-config, openssl, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "simple-http-server";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "TheWaWaR";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qhYsfbzEBbWii4r/G0trU7XiAMPrX/guRshyZE2xeJk=";
  };

  cargoSha256 = "sha256-aldAez28SZM4A8niIHk85pKeRzpxaZiQhV9Ch5dyblI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

  # Currently no tests are implemented, so we avoid building the package twice
  doCheck = false;

  meta = with lib; {
    description = "Simple HTTP server in Rust";
    homepage = "https://github.com/TheWaWaR/simple-http-server";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda mephistophiles ];
  };
}
