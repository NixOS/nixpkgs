{ stdenv, fetchFromGitHub, autoreconfHook, ncurses }:

stdenv.mkDerivation rec {
  name = "pick-${version}";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "thoughtbot";
    repo = "pick";
    rev = "v${version}";
    sha256 = "113if0jh7svwrwrxhrsbi7h1whfr5707v2ny4dc9kk2sjbv6b9pg";
  };

  buildInputs = [ ncurses ];

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Fuzzy text selection utility";
    license = licenses.mit;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux ++ platforms.darwin;
  };

}
