{ rustPlatform, fetchFromGitHub, lib, openssl, pkgconfig, stdenv, curl, Security, ... }:

rustPlatform.buildRustPackage rec {
  pname = "wasm-bindgen-cli";
  version = "0.2.60";

  src = fetchFromGitHub {
    owner = "rustwasm";
    repo = "wasm-bindgen";
    rev = version;
    sha256 = "1jr4v5y9hbkyg8gjkr3qc2qxwhyagfs8q3y3z248mr1919mcas8h";
  };

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security curl ];
  nativeBuildInputs = [ pkgconfig ];

  cargoSha256 = "08g110qahipgm1qyyihgqwnkr23w0gk1gp63ici5dj2qsxnc4mxv";
  cargoPatches = [ ./0001-Add-cargo.lock.patch ];
  cargoBuildFlags = [ "-p" pname ];

  meta = with lib; {
    homepage = https://rustwasm.github.io/docs/wasm-bindgen/;
    license = licenses.asl20;
    description = "Facilitating high-level interactions between wasm modules and JavaScript";
    maintainers = with maintainers; [ ma27 ];
    platforms = platforms.unix;
  };
}
