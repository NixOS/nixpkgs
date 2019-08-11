{ stdenv, fetchFromGitHub, autoreconfHook, ncurses, pkgconfig }:

stdenv.mkDerivation rec {
  name = "pick-${version}";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "calleerlandsson";
    repo = "pick";
    rev = "v${version}";
    sha256 = "0wm3220gqrwldiq0rjdraq5mw3i7d58zwzls8234sx9maf59h0k0";
  };

  buildInputs = [ ncurses ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Fuzzy text selection utility";
    license = licenses.mit;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux ++ platforms.darwin;
  };

}
