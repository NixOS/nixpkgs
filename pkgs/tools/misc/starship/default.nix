{ stdenv, fetchFromGitHub, rustPlatform, openssl, pkgconfig, libiconv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "starship";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "starship";
    repo = "starship";
    rev = "v${version}";
    sha256 = "0zq99ll0vyafr2piffazprhvbs3sxb6863cp2qw596ilqg7ffi04";
  };

  buildInputs = [ openssl ] ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.Security ];
  nativeBuildInputs = [ pkgconfig ];

  cargoSha256 = "0qlgng5j6l1r9j5vn3wnq25qr6f4nh10x90awiqyzz8jypb0ng2c";
  checkPhase = "cargo test -- --skip directory::home_directory --skip directory::directory_in_root";

  meta = with stdenv.lib; {
    description = "A minimal, blazing fast, and extremely customizable prompt for any shell";
    homepage = "https://starship.rs";
    license = licenses.isc;
    maintainers = with maintainers; [ bbigras ];
    platforms = platforms.all;
  };
}
