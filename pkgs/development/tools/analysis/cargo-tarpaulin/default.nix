{ lib, pkgconfig, rustPlatform, fetchFromGitHub, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tarpaulin";
  version = "0.14.3";

  src = fetchFromGitHub {
    owner = "xd009642";
    repo = "tarpaulin";
    rev = "${version}";
    sha256 = "03d8h5b174699yivaamlvaqzck9zs119jk29yf70dvxw7cs0nngv";
  };

  nativeBuildInputs = [
    pkgconfig
  ];
  buildInputs = [ openssl ];

  cargoSha256 = "0zzp2wyq48j6n64fm37qfl65cg4yzf9ysichhkmkc6viq8x0f66d";
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
