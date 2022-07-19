{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "simple-http-server";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "TheWaWaR";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ndLFN9FZZA+zsb+bjZ3gMvQJqo6I92erGOQ44H+/LCg=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  patches = [ ./0001-cargo-remove-vendored-openssl.patch ];
  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

  # Currently no tests are implemented, so we avoid building the package twice
  doCheck = false;

  meta = with lib; {
    description = "Simple HTTP server in Rust";
    homepage = "https://github.com/TheWaWaR/simple-http-server";
    license = licenses.mit;
    maintainers = with maintainers; [ mephistophiles ];
  };
}
