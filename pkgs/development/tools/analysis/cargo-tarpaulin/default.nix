{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, curl, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tarpaulin";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "xd009642";
    repo = "tarpaulin";
    rev = version;
    sha256 = "sha256-H/EQTS+d317icCZdOWTvykzIFQC7ia7/jYFkImgogps=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ curl Security ];

  cargoSha256 = "sha256-A3J5od6yT7eVU66WfvG/umne0RDBZCf8IvQpW6OTZSE=";
  #checkFlags = [ "--test-threads" "1" ];
  doCheck = false;

  meta = with lib; {
    description = "A code coverage tool for Rust projects";
    homepage = "https://github.com/xd009642/tarpaulin";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ hugoreeves ];
  };
}
