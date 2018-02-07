{ stdenv, fetchFromGitHub, autoreconfHook, ncurses, pkgconfig }:

stdenv.mkDerivation rec {
  name = "pick-${version}";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "calleerlandsson";
    repo = "pick";
    rev = "v${version}";
    sha256 = "0ypawbzpw188rxgv8x044iib3a517j5grgqnxy035ax5zzjavsrr";
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
