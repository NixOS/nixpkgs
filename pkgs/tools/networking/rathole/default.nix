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
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "rapiz1";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mebrhBmRPN+AydxKhe2g7ehe9r9rDqt5dXO8rRUIlJg=";
  };

  cargoSha256 = "sha256-uECM5j/xgrzPvrarDl6wxaD3Cn3Ut3aMM9OBvsc7ZqE=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ CoreServices ];

  __darwinAllowLocalNetworking = true;

  doCheck = false; # https://github.com/rapiz1/rathole/issues/222

  meta = with lib; {
    description = "A lightweight and high-performance reverse proxy for NAT traversal, written in Rust";
    homepage = "https://github.com/rapiz1/rathole";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
