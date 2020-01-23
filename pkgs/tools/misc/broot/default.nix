{ stdenv, rustPlatform, fetchFromGitHub, coreutils, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "broot";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "0z31yizjczr59z6vxgjc3lqlcr3m21bi5ly8pxp3s3w7nbfr369q";
  };

  cargoSha256 = "0cwj63907xwy1ali9p2wnzhlcb80c6nhf684fbbsg7awiyqgdak3";
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
