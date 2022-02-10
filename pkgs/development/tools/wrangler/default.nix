{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, curl, Security, CoreServices, CoreFoundation, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "wrangler";
  version = "1.19.8";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vJjAN7RmB1J4k7p2emfbjJxkpfph6piinmqVTR67HW0=";
  };

  cargoSha256 = "sha256-dDQvcYnceBPDc+yeePjZ1k4a2ujCSh1hJMYFjPGw/bE=";

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
