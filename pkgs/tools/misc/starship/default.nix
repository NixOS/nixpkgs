{ stdenv, fetchFromGitHub, rustPlatform
, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "starship";
  version = "0.34.1";

  src = fetchFromGitHub {
    owner = "starship";
    repo = pname;
    rev = "v${version}";
    sha256 = "1crs4kh3gzpzc18yi97xgs82xfhb77v54mfka9cq9v1qmghqdl8l";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  postPatch = ''
    substituteInPlace src/utils.rs \
      --replace "/bin/echo" "echo"
  '';

  cargoSha256 = "0d737xcnrzmy1adkj2lfdv8vqg2i8g8p15az4givdjls93mk271q";
  checkPhase = "cargo test -- --skip directory::home_directory --skip directory::directory_in_root";

  meta = with stdenv.lib; {
    description = "A minimal, blazing fast, and extremely customizable prompt for any shell";
    homepage = "https://starship.rs";
    license = licenses.isc;
    maintainers = with maintainers; [ bbigras davidtwco filalex77 ];
    platforms = platforms.all;
  };
}
