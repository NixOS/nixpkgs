{ rustPlatform
, fetchFromGitHub
, lib
, openssl
, pkg-config
, stdenv
, curl
, Security
, runCommand
}:

rustPlatform.buildRustPackage rec {
  pname = "wasm-bindgen-cli";
  version = "0.2.75";

  src =
    let
      tarball = fetchFromGitHub {
        owner = "rustwasm";
        repo = "wasm-bindgen";
        rev = version;
        hash = "sha256-eRAe6/v0Xrtd1d2k6p0WETZ2vkQkiDRZOds7y0DidY0=";
      };
    in
    runCommand "source" { } ''
      cp -R ${tarball} $out
      chmod -R +w $out
      cp ${./Cargo.lock} $out/Cargo.lock
    '';

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security curl ];
  nativeBuildInputs = [ pkg-config ];

  cargoHash = "sha256-xZrGBRnsBQKvqGkZyU7FQCkx0dHt/hXlrVLSvGKx27k=";
  cargoBuildFlags = [ "-p" pname ];

  meta = with lib; {
    homepage = "https://rustwasm.github.io/docs/wasm-bindgen/";
    license = licenses.asl20;
    description = "Facilitating high-level interactions between wasm modules and JavaScript";
    maintainers = with maintainers; [ ma27 nitsky rizary ];
    platforms = platforms.unix;
  };
}
