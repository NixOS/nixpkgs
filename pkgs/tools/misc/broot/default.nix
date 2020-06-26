{ stdenv, rustPlatform, fetchFromGitHub, coreutils, libiconv, Security, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "broot";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "1d8mqzc98v03nxn498mpyclihs5hmfgazna8z8vgah11jjdryj5k";
  };

  cargoSha256 = "152p3ddxz4d1lkfarcihvaf24rflbr9xnag6v2ynady517n9w80i";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  postPatch = ''
    substituteInPlace src/verb/builtin.rs --replace '"/bin/' '"${coreutils}/bin/'

    # Fill the version stub in the man page. We can't fill the date
    # stub reproducibly.
    substitute man/page man/broot.1 \
      --replace "#version" "${version}"
  '';

  postInstall = ''
    # install shell completion files
    OUT_DIR=$releaseDir/build/broot-*/out

    installShellCompletion --bash $OUT_DIR/{br,broot}.bash
    installShellCompletion --fish $OUT_DIR/{br,broot}.fish
    installShellCompletion --zsh $OUT_DIR/{_br,_broot}

    installManPage man/broot.1
  '';

  meta = with stdenv.lib; {
    description = "An interactive tree view, a fuzzy search, a balanced BFS descent and customizable commands";
    homepage = "https://dystroy.org/broot/";
    maintainers = with maintainers; [ magnetophon ];
    license = with licenses; [ mit ];
    platforms = platforms.all;
  };
}
