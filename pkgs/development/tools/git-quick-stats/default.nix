{ stdenv
, fetchFromGitHub
, makeWrapper
, coreutils
, gawk
, git
, gnugrep
, ncurses
, utillinux
}:

stdenv.mkDerivation rec {
  pname = "git-quick-stats";
  version = "2.1.4";

  src = fetchFromGitHub {
    repo = "git-quick-stats";
    owner = "arzzen";
    rev = version;
    sha256 = "0fg0fijghcz7hvbc9y8dfksz0qmsz700kc2mfb03y90kja99v68y";
  };

  nativeBuildInputs = [ makeWrapper ];

  installFlags = [
    "PREFIX=${builtins.placeholder "out"}"
  ];

  postInstall =
    let
      path = stdenv.lib.makeBinPath [
        coreutils
        gawk
        git
        gnugrep
        ncurses
        utillinux
      ];
    in
    ''
      wrapProgram $out/bin/git-quick-stats --suffix PATH : ${path}
    '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/arzzen/git-quick-stats";
    description = "A simple and efficient way to access various statistics in git repository";
    platforms = platforms.all;
    maintainers = [ maintainers.kmein ];
    license = licenses.mit;
  };
}
