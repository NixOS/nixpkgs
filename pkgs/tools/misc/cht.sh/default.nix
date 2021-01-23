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
  version = "unstable-2020-08-06";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "chubin";
    repo = "cheat.sh";
    rev = "9f99bec1f0293e84d6d8a990a1940c1422e3b0ce";
    sha256 = "1n4lgzsgg4502zh113d7pb1hw6bykqx6vpfp8j08z7y5clmdiwa6";
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

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "CLI client for cheat.sh, a community driven cheat sheet";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz evanjs ];
    homepage = "https://github.com/chubin/cheat.sh";
  };
}
