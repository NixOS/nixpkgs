{ stdenv, rustPlatform, fetchFromGitHub, coreutils, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "broot";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "1y2da4xcdsvvss4plbp77pqhi8fqjlnsgpcwq8fkc0vx049ijhcm";
  };

  cargoSha256 = "1h9jpyxvk76h06jgy3bwbr3ymhqypsyq05m99clkkrlwp8dnsgqq";
  verifyCargoDeps = true;

  nativeBuildInputs = [ installShellFiles ];

  postPatch = ''
    substituteInPlace src/verb_store.rs --replace '"/bin/' '"${coreutils}/bin/'
  '';

  postInstall = ''
    # install shell completion files
    OUT_DIR=target/release/build/broot-*/out

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
