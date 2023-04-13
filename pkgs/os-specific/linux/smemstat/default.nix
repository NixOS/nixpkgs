{ stdenv, lib, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  pname = "smemstat";
  version = "0.02.11";

  src = fetchFromGitHub {
    owner = "ColinIanKing";
    repo = pname;
    rev = "V${version}";
    hash = "sha256-RvHBrcyNB/zqxEY27twgMsjHNg8kzJryqnIAM7+vpg8=";
  };

  buildInputs = [ ncurses ];
  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
    "BASHDIR=${placeholder "out"}/share/bash-completion/completions"
  ];

  meta = with lib; {
    description = "Memory usage monitoring tool";
    homepage = "https://github.com/ColinIanKing/smemstat";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
  };
}
