{ lib, pkgconfig, rustPlatform, fetchFromGitHub, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tarpaulin";
  version = "0.13.3";

  src = fetchFromGitHub {
    owner = "xd009642";
    repo = "tarpaulin";
    rev = "${version}";
    sha256 = "1zc03frbag0lhxxbrdhip5h61ah16rqfcs314nyx7lfn3jd0gqzd";
  };

  nativeBuildInputs = [
    pkgconfig
  ];
  buildInputs = [ openssl ];

  cargoSha256 = "15qf5hb6gm4lm1dcsqqs8nmd43m1qmw2g2zpj3c0abs5fbdz8k3a";
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
