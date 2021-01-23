{ lib, stdenv
, fetchFromGitHub
, makeWrapper
, coreutils
, gawk
, git
, gnugrep
, ncurses
, util-linux
}:

stdenv.mkDerivation rec {
  pname = "git-quick-stats";
  version = "2.1.5";

  src = fetchFromGitHub {
    repo = "git-quick-stats";
    owner = "arzzen";
    rev = version;
    sha256 = "sha256-d5B+SSUXtOD4x+dChQsUCkiHuHcW3lOrL4QhQekY7cA=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installFlags = [
    "PREFIX=${builtins.placeholder "out"}"
  ];

  postInstall =
    let
      path = lib.makeBinPath [
        coreutils
        gawk
        git
        gnugrep
        ncurses
        util-linux
      ];
    in
    ''
      wrapProgram $out/bin/git-quick-stats --suffix PATH : ${path}
    '';

  meta = with lib; {
    homepage = "https://github.com/arzzen/git-quick-stats";
    description = "A simple and efficient way to access various statistics in git repository";
    platforms = platforms.all;
    maintainers = [ maintainers.kmein ];
    license = licenses.mit;
  };
}
