{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, libiconv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "starship";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "starship";
    repo = "starship";
    rev = "v${version}";
    sha256 = "0cj3r8c583xzraggwl1xb36790czha4dja6c3yvn5f19whmmf2g9";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.Security ];

  cargoSha256 = "1ldhkys44nkwjm6cmz1x2k5j4n79rqkh6km86hssjps5bzw6niw4";
  checkPhase = "cargo test -- --skip directory::home_directory --skip directory::directory_in_root";

  meta = with stdenv.lib; {
    description = "A minimal, blazing fast, and extremely customizable prompt for any shell";
    homepage = "https://starship.rs";
    license = licenses.isc;
    maintainers = with maintainers; [ bbigras ];
    platforms = platforms.all;
  };
}
