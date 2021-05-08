{ rustPlatform, fetchFromGitHub, pkg-config, openssl, lib }:

rustPlatform.buildRustPackage rec {
  pname = "trunk";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "thedodd";
    repo = "trunk";
    rev = "v${version}";
    sha256 = "W6d05MKquG1QFkvofqWk94+6j5q8yuAjNgZFG3Z3kNo=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  cargoSha256 = "Qv7knTmNYtw0tbyWhFIV7tYkQiwFxcNPAeNiGCyeV8s=";

  meta = with lib; {
    homepage = "https://github.com/thedodd/trunk";
    description = "Build, bundle & ship your Rust WASM application to the web";
    maintainers = with maintainers; [ freezeboy ];
    license = with licenses; [ asl20 ];
  };
}
