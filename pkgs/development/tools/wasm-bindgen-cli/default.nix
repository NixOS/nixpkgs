{ rustPlatform, fetchFromGitHub, lib, openssl, pkg-config, stdenv, curl, Security
, runCommand
}:

rustPlatform.buildRustPackage rec {
  pname = "wasm-bindgen-cli";
  version = "0.2.73";

  src =
    let
      tarball = fetchFromGitHub {
        owner = "rustwasm";
        repo = "wasm-bindgen";
        rev = version;
        sha256 = "sha256-JrfS9Z/ZqhoZXJxrxMSLpl2NiktTUkjW6q3xN9AU2zw=";
      };
    in runCommand "source" { } ''
      cp -R ${tarball} $out
      chmod -R +w $out
      cp ${./Cargo.lock} $out/Cargo.lock
    '';

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security curl ];
  nativeBuildInputs = [ pkg-config ];

  cargoSha256 = "sha256-2UBCcA4eBrSHrJjJdDprsysiOObg2GrC7QtveAydbhk=";
  cargoBuildFlags = [ "-p" pname ];

  meta = with lib; {
    homepage = "https://rustwasm.github.io/docs/wasm-bindgen/";
    license = licenses.asl20;
    description = "Facilitating high-level interactions between wasm modules and JavaScript";
    maintainers = with maintainers; [ ma27 rizary ];
    platforms = platforms.unix;
  };
}
