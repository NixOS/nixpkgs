{ stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, curl, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cloudflare-wrangler";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "wrangler";
    rev = "v${version}";
    sha256 = "1iqy45isrf103yaf1xa1ksxp566fr9jh29aakv95rrx6ayz2cw9c";
  };

  cargoSha256 = "0a0zyx5f46x0qfwkji1wffvk69qamaiqa85ix7mfa96r7ksrs3z3";

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
