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
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "rapiz1";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qhkgXS+Rku9OcFgFbHfELcjQmIHNvi3sC4bh5LKYzJQ=";
  };

  cargoSha256 = "sha256-3WY+VIRycqFmkVA+NdbU4glEkZecRM5eKI/reyNWVao=";

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
