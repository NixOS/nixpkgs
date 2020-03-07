{ rustPlatform, fetchFromGitHub, lib, openssl, pkgconfig, stdenv, curl, Security, ... }:

rustPlatform.buildRustPackage rec {
  pname = "wasm-bindgen-cli";
  version = "0.2.59";

  src = fetchFromGitHub {
    owner = "rustwasm";
    repo = "wasm-bindgen";
    rev = version;
    sha256 = "1i0hdky5dlkrzcphddm122yxfhgcvnszh4q1as0r41vhfs5ss597";
  };

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security curl ];
  nativeBuildInputs = [ pkgconfig ];

  cargoSha256 = "1cp8ns0cywzqchdw5hkg4fhxhqb6apxwjjasf1ksf3dgjwynlhzm";
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
