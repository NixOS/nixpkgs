{ rustPlatform, fetchFromGitHub, lib, openssl, pkgconfig, stdenv, curl, Security, ... }:

rustPlatform.buildRustPackage rec {
  pname = "wasm-bindgen-cli";
  version = "0.2.51";

  src = fetchFromGitHub {
    owner = "rustwasm";
    repo = "wasm-bindgen";
    rev = version;
    sha256 = "1pfkwak11k3ghvv985c20vhg4cyvf131a1f7k3sv5snw2klww7vm";
  };

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security curl ];
  nativeBuildInputs = [ pkgconfig ];

  cargoSha256 = "06zk2yzwpl569q5mgn56gprsfxxvyz4a2i949lls13daq1kal5pa";
  cargoPatches = [ ./0001-Add-cargo.lock-for-rustPlatform.buildRustPackage-in-.patch ];
  cargoBuildFlags = [ "-p" pname ];

  meta = with lib; {
    homepage = https://rustwasm.github.io/docs/wasm-bindgen/;
    license = licenses.asl20;
    description = "Facilitating high-level interactions between wasm modules and JavaScript";
    maintainers = with maintainers; [ ma27 ];
    platforms = platforms.unix;
  };
}
