{ stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, curl, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cloudflare-wrangler";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "wrangler";
    rev = "v" + version;
    sha256 = "1agl1cg34iklvniygrkq8dqsampvg17d3nsm0dcr6c3n5rj09gbi";
  };

  cargoSha256 = "0c2g6yghwqjy21yfdcri4v9aqizd06ww3zx2snns51gnqqk8r57k";

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
    description = "A CLI tool designed for folks who are interested in using Cloudflare Workers.";
    homepage = https://github.com/cloudflare/wrangler;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
