{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, curl, Security, CoreServices, CoreFoundation, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "wrangler";
  version = "1.19.11";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8Vka8HTU0YkTS1DeQuqVLsnRGnig7Aiql5e/6NBk7qs=";
  };

  cargoSha256 = "sha256-bw6Z4SW+NOFFpUJ5xGwdccv8KQnSri/TFxAJp+9fsWk=";

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
