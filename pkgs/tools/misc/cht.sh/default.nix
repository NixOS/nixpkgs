{ stdenv
, fetchFromGitHub
, makeWrapper
, curl
, ncurses
, rlwrap
, xsel
}:

stdenv.mkDerivation rec {
  name = "cht.sh-${version}";
  version = "unstable-2018-11-02";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "chubin";
    repo = "cheat.sh";
    rev = "9595805ac68b3c096f7c51fa024dcb97a7dfac44";
    sha256 = "11g8say5fksg0zg0bqrgl92rprn4lwp20g9rz1i0r38f0jy3nyrf";
  };

  # Fix ".cht.sh-wrapped" in the help message
  postPatch = "substituteInPlace share/cht.sh.txt --replace '\${0##*/}' cht.sh";

  installPhase = ''
    install -m755 -D share/cht.sh.txt "$out/bin/cht.sh"
    wrapProgram "$out/bin/cht.sh" \
      --prefix PATH : "${stdenv.lib.makeBinPath [ curl rlwrap ncurses xsel ]}"
  '';

  meta = with stdenv.lib; {
    description = "CLI client for cheat.sh, a community driven cheat sheet";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
    homepage = https://github.com/chubin/cheat.sh;
  };
}

