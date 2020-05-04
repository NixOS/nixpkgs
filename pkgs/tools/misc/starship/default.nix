{ stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl
, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "starship";
  version = "0.41.0";

  src = fetchFromGitHub {
    owner = "starship";
    repo = pname;
    rev = "v${version}";
    sha256 = "1m5pi49g3pj2qr5slyasda5xp9lz3xhz3qb9k0pa6fvcn9581r9q";
  };

  nativeBuildInputs = stdenv.lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs = stdenv.lib.optionals stdenv.isLinux [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  postPatch = ''
    substituteInPlace src/utils.rs \
      --replace "/bin/echo" "echo"
  '';

  cargoSha256 = "18z1p8xj1v9w6amc52gc2vcn5f4z8k71ig20zmj005v24si9pfwf";
  checkPhase = "cargo test -- --skip directory::home_directory --skip directory::directory_in_root";

  meta = with stdenv.lib; {
    description = "A minimal, blazing fast, and extremely customizable prompt for any shell";
    homepage = "https://starship.rs";
    license = licenses.isc;
    maintainers = with maintainers; [ bbigras davidtwco filalex77 ];
    platforms = platforms.all;
  };
}
