{ stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, curl, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cloudflare-wrangler";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "wrangler";
    rev = "v" + version;
    sha256 = "0vc7f3jki2fdwlgpwhaxzm58g2898wpwbib7dmibb9kxv4jna8gj";
  };

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;
  cargoSha256 = "1f3gy3agpdg6pck5acxjfrd89hyp9x1byqhfizlizbfmwrqs4il8";

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
