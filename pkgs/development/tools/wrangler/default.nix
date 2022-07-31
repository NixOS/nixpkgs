{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, curl, Security, CoreServices, CoreFoundation, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "wrangler";
  version = "1.19.12";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HnenF3X/6tvzwlbuOiQAvB76GrdRsqETG+3fp1fx334=";
  };

  cargoSha256 = "sha256-mJyuqVSiuBKI/x3P865W1/ei5Ya2mV5LVXzaL3peocE=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ curl CoreFoundation CoreServices Security libiconv ];

  OPENSSL_NO_VENDOR = 1;

  # tries to use "/homeless-shelter" and fails
  doCheck = false;

  meta = with lib; {
    description = "A CLI tool designed for folks who are interested in using Cloudflare Workers";
    homepage = "https://github.com/cloudflare/wrangler";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
