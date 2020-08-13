{ lib, pkgconfig, rustPlatform, fetchFromGitHub, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tarpaulin";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "xd009642";
    repo = "tarpaulin";
    rev = "${version}";
    sha256 = "1skiaiz3xyi6cf62fkg7i7ahncm7vcg3aq4s4a5lrls30gr0n288";
  };

  nativeBuildInputs = [
    pkgconfig
  ];
  buildInputs = [ openssl ];

  cargoSha256 = "1klmdwpqk995pdyms40x7gk4l2mf4ncj7cgknl91kmyvpn4j1y4g";
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
