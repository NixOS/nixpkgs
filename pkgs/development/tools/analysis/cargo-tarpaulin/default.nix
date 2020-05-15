{ lib, pkgconfig, rustPlatform, fetchFromGitHub, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tarpaulin";
  version = "0.12.4";

  src = fetchFromGitHub {
    owner = "xd009642";
    repo = "tarpaulin";
    rev = "${version}";
    sha256 = "0y58800n61s8wmpcpgw5vpywznwwbp0d30fz2z0kjx4mpwmva4g4";
  };

  nativeBuildInputs = [
    pkgconfig
  ];
  buildInputs = [ openssl ];

  cargoSha256 = "12hkzq2xn4g5k94kjirjnnz4dddqg7akxnp3qyfkz092vvp25k9z";
  #checkFlags = [ "--test-threads" "1" ];
  doCheck = false;

  meta = with lib; {
    description = "A code coverage tool for Rust projects";
    homepage = "https://github.com/xd009642/tarpaulin";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ hugoreeves ];
    platforms = platforms.linux;
  };
}
