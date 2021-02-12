{ lib, pkg-config, rustPlatform, fetchFromGitHub, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tarpaulin";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "xd009642";
    repo = "tarpaulin";
    rev = version;
    sha256 = "1z104cd3wg718x1d89znppx4h6f0c6icgmpcllyrd0d19lb71a2b";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [ openssl ];

  cargoSha256 = "0rf2v088n0h41v5lsz0pz89fjs36zdlhzwhcaxj1853gijg1wmla";
  #checkFlags = [ "--test-threads" "1" ];
  doCheck = false;

  meta = with lib; {
    description = "A code coverage tool for Rust projects";
    homepage = "https://github.com/xd009642/tarpaulin";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ hugoreeves ];
    platforms = [ "x86_64-linux" ];
  };
}
