{ stdenv, fetchFromGitHub, autoreconfHook, ncurses }:

stdenv.mkDerivation rec {
  name = "pick-${version}";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "calleerlandsson";
    repo = "pick";
    rev = "v${version}";
    sha256 = "1x7ql530rj4yj50dzp8526mz92g4hhqxnig1qgiq3h3k815p31qb";
  };

  buildInputs = [ ncurses ];

  nativeBuildInputs = [ autoreconfHook ];

  postPatch = ''
    sed -i -e 's/\[curses]/\[ncurses]/g' configure.ac
  '';

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Fuzzy text selection utility";
    license = licenses.mit;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux ++ platforms.darwin;
  };

}
