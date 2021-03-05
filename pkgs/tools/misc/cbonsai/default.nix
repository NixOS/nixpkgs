{ lib, stdenv, fetchFromGitLab, pkg-config, ncurses }:

stdenv.mkDerivation rec {
  pname = "cbonsai";
  version = "1.0.0";

  src = fetchFromGitLab {
    owner = "jallbrit";
    repo = "cbonsai";
    rev = "v${version}";
    sha256 = "sha256-RythVMwTvAdnDYYnnIHzjwiZkFK4S4j0k97eI4wkg8k=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ncurses ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "cbonsai is a bonsai tree generator, written in C using ncurses.";
    homepage = "https://gitlab.com/jallbrit/cbonsai";
    license = licenses.gpl3;
    maintainers = with maintainers; [ thelegy queezle ];
    platforms = platforms.unix;
  };
}
