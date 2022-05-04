{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, curl, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tarpaulin";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "xd009642";
    repo = "tarpaulin";
    rev = version;
    sha256 = "sha256-LMHaRGZZqFUCbrChzlLA/gUArlGC5DUI2fc1bkLU2CA=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ curl Security ];

  cargoSha256 = "sha256-ei+ilmrlJYmt08A+aV2Rc5pn5dkuEBgfm9kyLkfFe9A=";
  #checkFlags = [ "--test-threads" "1" ];
  doCheck = false;

  meta = with lib; {
    description = "A code coverage tool for Rust projects";
    homepage = "https://github.com/xd009642/tarpaulin";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ hugoreeves ];
  };
}
