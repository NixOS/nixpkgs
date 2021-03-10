{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, curl, Security, CoreServices, CoreFoundation }:

rustPlatform.buildRustPackage rec {
  pname = "wrangler";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xhldarzb71x4k7ydk4yd6g0qv6y2l0mn2lc43hvl9jm29pnz95q";
  };

  cargoSha256 = "0w845virvw7mvibc76ar2hbffhfzj2v8v1xkrsssrgzyaryb48jk";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ curl CoreFoundation CoreServices Security ];

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
