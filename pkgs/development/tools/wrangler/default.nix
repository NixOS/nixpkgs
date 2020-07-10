{ stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, curl, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "wrangler";
  version = "1.10.3";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = pname;
    rev = "v${version}";
    sha256 = "0703zlrmv0if575rj1mrgfg1a5qbf98sqjhhj09hab69i96wbrk9";
  };

  cargoSha256 = "0znzyqzvbqcl4mmxpsvaf592xrs968x57czj45jibmafq033dbfa";

  nativeBuildInputs = stdenv.lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs = stdenv.lib.optionals stdenv.isLinux [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [
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
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.all;
  };
}
