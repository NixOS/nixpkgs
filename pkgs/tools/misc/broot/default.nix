{ stdenv, rustPlatform, fetchFromGitHub, coreutils, libiconv, Security, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "broot";
  version = "0.13.6";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "08d0zddqqymxj1qcp8c78r7mpii1piy6awaf135jxhzwi775sqqv";
  };

  cargoSha256 = "1cxvx51zkmhszmgwsi0aj469xz98v5nk79zvqfyma27gsnh8jczr";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  postPatch = ''
    substituteInPlace src/verb_store.rs --replace '"/bin/' '"${coreutils}/bin/'
  '';

  postInstall = ''
    # install shell completion files
    OUT_DIR=$releaseDir/build/broot-*/out

    installShellCompletion --bash $OUT_DIR/{br,broot}.bash
    installShellCompletion --fish $OUT_DIR/{br,broot}.fish
    installShellCompletion --zsh $OUT_DIR/{_br,_broot}
  '';

  meta = with stdenv.lib; {
    description = "An interactive tree view, a fuzzy search, a balanced BFS descent and customizable commands";
    homepage = "https://dystroy.org/broot/";
    maintainers = with maintainers; [ magnetophon ];
    license = with licenses; [ mit ];
    platforms = platforms.all;
  };
}
