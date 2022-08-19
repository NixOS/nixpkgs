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
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "rapiz1";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gqWgx03mUk6+9K4Yw5PHEBwFxsOR+48wvngT+wQnN1k=";
  };

  cargoSha256 = "sha256-dafOgZtiszkoi97PpAVMtdvJd5O3EK9hDVNLJ32FYzE=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin [ CoreServices ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "A lightweight and high-performance reverse proxy for NAT traversal, written in Rust";
    homepage = "https://github.com/rapiz1/rathole";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
