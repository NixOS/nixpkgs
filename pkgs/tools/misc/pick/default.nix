{ stdenv, fetchFromGitHub, autoreconfHook, ncurses, pkgconfig }:

stdenv.mkDerivation rec {
  name = "pick-${version}";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "calleerlandsson";
    repo = "pick";
    rev = "v${version}";
    sha256 = "0s0mn9iz17ldhvahggh9rsmgfrjh0kvk5bh4p9xhxcn7rcp0h5ka";
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
