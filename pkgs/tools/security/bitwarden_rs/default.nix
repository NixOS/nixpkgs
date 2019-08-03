{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig, openssl, Security, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "bitwarden_rs";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "dani-garcia";
    repo = pname;
    rev = version;
    sha256 = "0jfb4b2lp2v01aw615lx0qj1qh73hyrbjn9kva7zqp74wcfw12gp";
  };

  cargoPatches = [
    # type annotations required: cannot resolve `std::string::String: std::convert::AsRef<_>`
    ./cargo-lock-lettre.patch
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ] ++ stdenv.lib.optionals stdenv.isDarwin [ Security CoreServices ];

  RUSTC_BOOTSTRAP = 1;

  cargoSha256 = "0p39gqrqdmgqhngp1qyh6jl0sp0ifj5n3bxfqafjbspb4zph3ls4";

  meta = with stdenv.lib; {
    description = "An unofficial lightweight implementation of the Bitwarden server API using Rust and SQLite";
    homepage = https://github.com/dani-garcia/bitwarden_rs;
    license = licenses.gpl3;
    maintainers = with maintainers; [ msteen ];
    platforms = platforms.all;
  };
}
