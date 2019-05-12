{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig, openssl, Security, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "bitwarden_rs";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "dani-garcia";
    repo = pname;
    rev = version;
    sha256 = "14c2blzkmdd9s0gpf6b7y141yx9s2v2gmwy5l1lgqjhi3h6jpcqr";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ] ++ stdenv.lib.optionals stdenv.isDarwin [ Security CoreServices ];

  RUSTC_BOOTSTRAP = 1;

  cargoSha256 = "038l6alcdc0g4avpbzxgd2k09nr3wrsbry763bq2c77qqgwldj8r";

  meta = with stdenv.lib; {
    description = "An unofficial lightweight implementation of the Bitwarden server API using Rust and SQLite";
    homepage = https://github.com/dani-garcia/bitwarden_rs;
    license = licenses.gpl3;
    maintainers = with maintainers; [ msteen ];
    platforms = platforms.all;
  };
}
