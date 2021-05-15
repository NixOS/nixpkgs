{ lib, stdenv, fetchFromGitHub, autoreconfHook, ncurses, pkg-config }:

stdenv.mkDerivation rec {
  pname = "pick";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "calleerlandsson";
    repo = "pick";
    rev = "v${version}";
    sha256 = "0wm3220gqrwldiq0rjdraq5mw3i7d58zwzls8234sx9maf59h0k0";
  };

  buildInputs = [ ncurses ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Fuzzy text selection utility";
    license = licenses.mit;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux ++ platforms.darwin;
  };

}
