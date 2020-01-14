{ stdenv, fetchFromGitHub, rustPlatform
, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "starship";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "starship";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wqxcfd7ams3k0swps9037dzc1qzxhpbqaz4qjw9jabgcl6jkb6v";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  postPatch = ''
    substituteInPlace src/utils.rs \
      --replace "/bin/echo" "echo"
  '';

  cargoSha256 = "0gcca3vlwrfhw9k4r9zc1raflr1m4xws9dpdxjh1kz34f9g88ijg";
  checkPhase = "cargo test -- --skip directory::home_directory --skip directory::directory_in_root";

  meta = with stdenv.lib; {
    description = "A minimal, blazing fast, and extremely customizable prompt for any shell";
    homepage = "https://starship.rs";
    license = licenses.isc;
    maintainers = with maintainers; [ bbigras davidtwco filalex77 ];
    platforms = platforms.all;
  };
}
