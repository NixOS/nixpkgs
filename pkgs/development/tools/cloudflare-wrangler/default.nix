{ stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, curl, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cloudflare-wrangler";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "wrangler";
    rev = "v${version}";
    sha256 = "09rq6lnv9993ah49jxqaqqhv5xxj51gxlqdi99wkj217cxp9gqqn";
  };

  cargoSha256 = "0vlb1g4pki84n2zf6w3bisa7jpv0ws8nb3lgr0bkjrirf60a9xsk";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ stdenv.lib.optionals stdenv.isDarwin [
                  curl
                  darwin.apple_sdk.frameworks.Security
                  darwin.apple_sdk.frameworks.CoreServices
                  darwin.apple_sdk.frameworks.CoreFoundation
                ];

  # tries to use "/homeless-shelter" and fails
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A CLI tool designed for folks who are interested in using Cloudflare Workers";
    homepage = "https://github.com/cloudflare/wrangler";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
