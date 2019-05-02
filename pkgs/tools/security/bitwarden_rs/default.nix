{ lib, rustPlatform, fetchFromGitHub, pkgconfig, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "bitwarden_rs";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "dani-garcia";
    repo = pname;
    rev = version;
    sha256 = "0jz9r6ck6sfz4ig95x0ja6g5ikyq6z0xw1zn9zf4kxha4klqqbkx";
  };

  buildInputs = [ pkgconfig openssl ];

  RUSTC_BOOTSTRAP = 1;

  cargoSha256 = "02xrz7vq8nan70f07xyf335blfmdc6gaz9sbfjipsi1drgfccf09";

  meta = with lib; {
    description = "An unofficial lightweight implementation of the Bitwarden server API using Rust and SQLite";
    homepage = https://github.com/dani-garcia/bitwarden_rs;
    license = licenses.gpl3;
    maintainers = with maintainers; [ msteen ];
    platforms = platforms.all;
  };
}
