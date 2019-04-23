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

  cargoSha256 = "0bzid5wrpcrghazv5652ghyv4amp298p5kfridswv175kmr9gg0x";

  meta = with lib; {
    description = "An unofficial lightweight implementation of the Bitwarden server API using Rust and SQLite";
    homepage = https://github.com/dani-garcia/bitwarden_rs;
    license = licenses.gpl3;
    maintainers = with maintainers; [ msteen ];
    platforms = platforms.all;
  };
}
