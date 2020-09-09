{ rustPlatform, fetchFromGitHub, lib, openssl, pkgconfig, stdenv, curl, Security
, runCommand
}:

rustPlatform.buildRustPackage rec {
  pname = "wasm-bindgen-cli";
  version = "0.2.67";

  src =
    let
      tarball = fetchFromGitHub {
        owner = "rustwasm";
        repo = "wasm-bindgen";
        rev = version;
        sha256 = "0qx178aicbn59b150j5r78zya5n0yljvw4c4lhvg8x4cpfshjb5j";
      };
    in runCommand "source" { } ''
      cp -R ${tarball} $out
      chmod -R +w $out
      cp ${./Cargo.lock} $out/Cargo.lock
    '';

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security curl ];
  nativeBuildInputs = [ pkgconfig ];

  cargoSha256 = "0chpw6syqxn824cbkdjx1s26vmajx511gc4mp9y64vy7b7asba6x";
  cargoBuildFlags = [ "-p" pname ];

  meta = with lib; {
    homepage = "https://rustwasm.github.io/docs/wasm-bindgen/";
    license = licenses.asl20;
    description = "Facilitating high-level interactions between wasm modules and JavaScript";
    maintainers = with maintainers; [ ma27 ];
    platforms = platforms.unix;
  };
}
