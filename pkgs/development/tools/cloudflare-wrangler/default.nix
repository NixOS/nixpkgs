{ stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, curl, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cloudflare-wrangler";
  version = "1.8.4";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "wrangler";
    rev = "v${version}";
    sha256 = "1lllam0zgr26fbg04hnw1sy35grwrs4br8cx4r9vqjf113cyr80x";
  };

  cargoSha256 = "0yvnqp15iqv142vcgsmcad07r5nnp417c0iqa9qgyzn39ssgpn0r";

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
