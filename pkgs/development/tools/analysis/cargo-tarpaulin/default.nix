{ lib, pkgconfig, rustPlatform, fetchFromGitHub, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tarpaulin";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "xd009642";
    repo = "tarpaulin";
    rev = "${version}";
    sha256 = "0sjd0xvphrc2kxzvwk4l0dnshn062ghn9f29h7k2ifsf2myl7066";
  };

  nativeBuildInputs = [
    pkgconfig
  ];
  buildInputs = [ openssl ];

  cargoSha256 = "1w9pymg989kl29s4dhr32ck0nq61pg9h1qf4aad1sv83llbqahq0";
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
