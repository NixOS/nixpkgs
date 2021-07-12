{ lib, stdenv
, fetchFromGitHub
, unstableGitUpdater
, makeWrapper
, curl
, ncurses
, rlwrap
, xsel
}:

stdenv.mkDerivation {
  pname = "cht.sh";
  version = "unstable-2021-04-25";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "chubin";
    repo = "cheat.sh";
    rev = "6d83c4d76c82a87cf6df436a5ab73e3b7c819e66";
    sha256 = "dXLNPhkfbQIhFZixC674Fcegyo8+Um7E6cm56vMpCYI=";
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
      --prefix PATH : "${lib.makeBinPath [ curl rlwrap ncurses xsel ]}"
  '';

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/chubin/cheat.sh.git";
  };

  meta = with lib; {
    description = "CLI client for cheat.sh, a community driven cheat sheet";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz evanjs ];
    homepage = "https://github.com/chubin/cheat.sh";
  };
}
