{ stdenv
, fetchFromGitHub
, makeWrapper
, curl
, ncurses
, rlwrap
, xsel
}:

stdenv.mkDerivation {
  pname = "cht.sh";
  version = "unstable-2019-08-06";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "chubin";
    repo = "cheat.sh";
    rev = "f507ba51d6bc1ae6c7df808cadbe4f8603951b6b";
    sha256 = "0r7x9a3qzzkbd1m5zdlkpmhx0p7b7ja42190s7fidls3dsm710g0";
  };

  # Fix ".cht.sh-wrapped" in the help message
  postPatch = "substituteInPlace share/cht.sh.txt --replace '\${0##*/}' cht.sh";

  installPhase = ''
    install -m755 -D share/cht.sh.txt "$out/bin/cht.sh"

    # install shell completion files
    mkdir -p $out/share/bash-completion/completions $out/share/zsh/site-functions
    mv share/bash_completion.txt $out/share/bash-completion/completions/cht.sh
    cp share/zsh.txt $out/share/zsh/site-functions/_cht

    wrapProgram "$out/bin/cht.sh" \
      --prefix PATH : "${stdenv.lib.makeBinPath [ curl rlwrap ncurses xsel ]}"
  '';

  meta = with stdenv.lib; {
    description = "CLI client for cheat.sh, a community driven cheat sheet";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz evanjs ];
    homepage = https://github.com/chubin/cheat.sh;
  };
}

