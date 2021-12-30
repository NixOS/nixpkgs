{ lib, stdenv, fetchFromGitHub, rustPlatform, darwin, boringtun, testVersion }:

rustPlatform.buildRustPackage rec {
  pname = "boringtun";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = pname;
    rev = "v${version}";
    sha256 = "0b57c7z87xwrirmq9aa9jswqyj5bavkifmq7a9hgfphcmwcskmdb";
  };

  cargoSha256 = "1xn6scc8nrb9xk89hsp9v67jvyww23rjaq5fcagpbqdwf5dvg4ja";

  buildInputs = lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  # Testing this project requires sudo, Docker and network access, etc.
  doCheck = false;

  passthru.tests.version = testVersion { package = boringtun; };

  meta = with lib; {
    description = "Userspace WireGuard® implementation in Rust";
    homepage = "https://github.com/cloudflare/boringtun";
    license = licenses.bsd3;
    maintainers = with maintainers; [ xrelkd marsam ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
