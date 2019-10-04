{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, libiconv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "starship";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "starship";
    repo = "starship";
    rev = "v${version}";
    sha256 = "0v6x19rv7i03rp4wmg97yw9wybafpn8r2gb0l6ha3d218vhb71ln";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.Security ];

  cargoSha256 = "0c82k6aw245vsqkcrg6bhqhylfbxdszcr040mrz7cz9ydxcb58b9";
  checkPhase = "cargo test -- --skip directory::home_directory --skip directory::directory_in_root";

  meta = with stdenv.lib; {
    description = "A minimal, blazing fast, and extremely customizable prompt for any shell";
    homepage = "https://starship.rs";
    license = licenses.isc;
    maintainers = with maintainers; [ bbigras ];
    platforms = platforms.all;
  };
}
