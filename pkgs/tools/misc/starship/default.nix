{ stdenv, fetchFromGitHub, rustPlatform, openssl, pkgconfig, libiconv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "starship";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "starship";
    repo = "starship";
    rev = "v${version}";
    sha256 = "0y6ixl3i1brak226hh02da1zzlcv41f0kb648dqii6dzyhrwhrld";
  };

  buildInputs = [ openssl ] ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.Security ];
  nativeBuildInputs = [ pkgconfig ];

  cargoSha256 = "1xk4ngxhgww921fk40d4ziprnzgp927lhdwwzcifcb0hdyl0854p";
  checkPhase = "cargo test -- --skip directory::home_directory --skip directory::directory_in_root";

  meta = with stdenv.lib; {
    description = "A minimal, blazing fast, and extremely customizable prompt for any shell";
    homepage = "https://starship.rs";
    license = licenses.isc;
    maintainers = with maintainers; [ bbigras ];
    platforms = platforms.all;
  };
}
