{ stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "boringtun";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = pname;
    rev = "v${version}";
    sha256 = "0b57c7z87xwrirmq9aa9jswqyj5bavkifmq7a9hgfphcmwcskmdb";
  };

  cargoSha256 = "0bms93xg75b23ls2hb8dv26y4al4nr67pqcm57rp9d4rbsfafg8c";

  buildInputs = stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  # Testing this project requires sudo, Docker and network access, etc.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Userspace WireGuard® implementation in Rust";
    homepage = "https://github.com/cloudflare/boringtun";
    license = licenses.bsd3;
    maintainers = with maintainers; [ xrelkd marsam ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
