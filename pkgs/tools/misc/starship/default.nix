{ stdenv, fetchFromGitHub, rustPlatform
, pkg-config, openssl
, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "starship";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "starship";
    repo = pname;
    rev = "v${version}";
    sha256 = "1g4cpnlz2gx4c3cmqx3a69iwjs2cg8p86l0zd198h6fv8pa1i16y";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ (stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ]);

  postPatch = ''
    substituteInPlace src/utils.rs \
      --replace "/bin/echo" "echo"
  '';

  cargoSha256 = "03qrcf0y6j22asp7x10di6xi8hgai84kvh1imiw9vibxp90868bh";
  checkPhase = "cargo test -- --skip directory::home_directory --skip directory::directory_in_root";

  meta = with stdenv.lib; {
    description = "A minimal, blazing fast, and extremely customizable prompt for any shell";
    homepage = "https://starship.rs";
    license = licenses.isc;
    maintainers = with maintainers; [ bbigras davidtwco filalex77 ];
    platforms = platforms.all;
  };
}
