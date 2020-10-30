{ stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, curl, darwin, perl }:

rustPlatform.buildRustPackage rec {
  pname = "wrangler";
  version = "1.12.2";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = pname;
    rev = "v${version}";
    sha256 = "1w0j6if1fnih1036hlb9a3c6wgjw4p057llhjf0f3d568ah1244a";
  };

  cargoSha256 = "0d9wvdjjakznz8dnqx4gqxh0xkxrh4229460hg6dr9qn492p7nfx";

  nativeBuildInputs = stdenv.lib.optionals stdenv.isLinux [ pkg-config perl ];

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
  };
}
