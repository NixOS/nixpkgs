{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, CoreServices
}:
rustPlatform.buildRustPackage rec {
  pname = "rathole";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "rapiz1";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YauQg+P4Y8oO8Kn6FB3NxBI7PHoo/bjS38bM1lFeCH0=";
  };

  cargoSha256 = "sha256-OcPmHqjW79SKMET6J5HIwmR5vESh+PJcQjSMsqmnIb8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ CoreServices ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "A lightweight and high-performance reverse proxy for NAT traversal, written in Rust";
    homepage = "https://github.com/rapiz1/rathole";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
