{ stdenv, fetchFromGitHub, rustPlatform, libiconv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "starship";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "starship";
    repo = pname;
    rev = "v${version}";
    sha256 = "1bps40rzljxihl87hbbdlas5v9lphhsjzgaqz2y0haqwjj1vjpm9";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.Security ];

  postPatch = ''
    substituteInPlace src/utils.rs \
      --replace "/bin/echo" "echo"
  '';

  cargoSha256 = "110ajwgdshakcqxfnqi30yy0miikp2qx86flwfkd78jawfll2krp";
  checkPhase = "cargo test -- --skip directory::home_directory --skip directory::directory_in_root";

  meta = with stdenv.lib; {
    description = "A minimal, blazing fast, and extremely customizable prompt for any shell";
    homepage = "https://starship.rs";
    license = licenses.isc;
    maintainers = with maintainers; [ bbigras davidtwco filalex77 ];
    platforms = platforms.all;
  };
}
