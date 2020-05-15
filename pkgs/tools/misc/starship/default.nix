{ stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl
, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "starship";
  version = "0.41.3";

  src = fetchFromGitHub {
    owner = "starship";
    repo = pname;
    rev = "v${version}";
    sha256 = "0f3d95abivbmjqdzw9pbdbis96sfds26xv3k8k9skxml8iqzq29c";
  };

  nativeBuildInputs = stdenv.lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs = stdenv.lib.optionals stdenv.isLinux [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  postPatch = ''
    substituteInPlace src/utils.rs \
      --replace "/bin/echo" "echo"
  '';

  cargoSha256 = "10h0arvl3gf5hg530d24ypj4yzk3zhm8mgkhz0v61y0jcdy2zdrm";
  checkPhase = "cargo test -- --skip directory::home_directory --skip directory::directory_in_root";

  meta = with stdenv.lib; {
    description = "A minimal, blazing fast, and extremely customizable prompt for any shell";
    homepage = "https://starship.rs";
    license = licenses.isc;
    maintainers = with maintainers; [ bbigras davidtwco filalex77 Frostman ];
    platforms = platforms.all;
  };
}
