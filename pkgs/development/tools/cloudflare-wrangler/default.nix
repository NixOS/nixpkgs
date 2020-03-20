{ stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, curl, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cloudflare-wrangler";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "wrangler";
    rev = "v${version}";
    sha256 = "0lh06cnjddmy5h5xvbkg8f97vw2v0wr5fi7vrs3nnidiz7x4rsja";
  };

  cargoSha256 = "1q7vilh0bynhdz5bbpig5ibaqvk2153n07gmc715qb80w92sjw7w";

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
