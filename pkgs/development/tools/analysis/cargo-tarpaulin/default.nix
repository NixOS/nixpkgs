{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, curl, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tarpaulin";
  version = "0.25.1";

  src = fetchFromGitHub {
    owner = "xd009642";
    repo = "tarpaulin";
    rev = version;
    sha256 = "sha256-JTkVNy2wqPIQ5mVcptI10a3Ghhdygnm9dmwUmiDqYjE=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ curl Security ];

  cargoHash = "sha256-t4L3HSOGk/lAL8mOaVl/pm3kE0CVVzsYpyu0V6zeIFQ=";
  #checkFlags = [ "--test-threads" "1" ];
  doCheck = false;

  meta = with lib; {
    description = "A code coverage tool for Rust projects";
    homepage = "https://github.com/xd009642/tarpaulin";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ hugoreeves ];
  };
}
