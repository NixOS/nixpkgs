{ rustPlatform, fetchFromGitHub, lib, openssl, pkgconfig, stdenv, curl, Security, ... }:

rustPlatform.buildRustPackage rec {
  pname = "wasm-bindgen-cli";
  version = "0.2.62";

  src = fetchFromGitHub {
    owner = "rustwasm";
    repo = "wasm-bindgen";
    rev = version;
    sha256 = "0d3ph3g220nvzwxa71rch03j5c0w06v8z4lmlyp5kky6p86r37hz";
  };

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security curl ];
  nativeBuildInputs = [ pkgconfig ];

  cargoSha256 = "13lj2yx2bcwac1b4gpwcgiwqvy178zis6r1pidn4pgwqv7zxa7p2";
  cargoPatches = [ ./0001-Add-cargo.lock.patch ];
  cargoBuildFlags = [ "-p" pname ];

  meta = with lib; {
    homepage = "https://rustwasm.github.io/docs/wasm-bindgen/";
    license = licenses.asl20;
    description = "Facilitating high-level interactions between wasm modules and JavaScript";
    maintainers = with maintainers; [ ma27 ];
    platforms = platforms.unix;
  };
}
