{ rustPlatform, fetchFromGitHub, lib, openssl, pkgconfig, stdenv, curl, Security
, runCommand
}:

rustPlatform.buildRustPackage rec {
  pname = "wasm-bindgen-cli";
  version = "0.2.69";

  src =
    let
      tarball = fetchFromGitHub {
        owner = "rustwasm";
        repo = "wasm-bindgen";
        rev = version;
        sha256 = "1psylk3hlx0ahwib3ph8qdk0jwlp8qzc6dv61002rj7ns28vs4mx";
      };
    in runCommand "source" { } ''
      cp -R ${tarball} $out
      chmod -R +w $out
      cp ${./Cargo.lock} $out/Cargo.lock
    '';

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security curl ];
  nativeBuildInputs = [ pkgconfig ];

  cargoSha256 = "1wrfly7c3an1mjqm7v13mlvx57hwlcxfjijkimicck04q6qdhbp6";
  cargoBuildFlags = [ "-p" pname ];

  meta = with lib; {
    homepage = "https://rustwasm.github.io/docs/wasm-bindgen/";
    license = licenses.asl20;
    description = "Facilitating high-level interactions between wasm modules and JavaScript";
    maintainers = with maintainers; [ ma27 rizary ];
    platforms = platforms.unix;
  };
}
