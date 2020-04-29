{ rustPlatform, fetchFromGitHub, lib, openssl, pkgconfig, stdenv, curl, Security, ... }:

rustPlatform.buildRustPackage rec {
  pname = "wasm-bindgen-cli";
  version = "0.2.61";

  src = fetchFromGitHub {
    owner = "rustwasm";
    repo = "wasm-bindgen";
    rev = version;
    sha256 = "1lz4yscs17vix96isqpwwjhjcgj46zh2ljiwvfsk44wky8vwkyb7";
  };

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security curl ];
  nativeBuildInputs = [ pkgconfig ];

  cargoSha256 = "1vblvajhx5gn08rinv6bnw61zah62il015rzm0d4vs2b9p0iaann";
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
