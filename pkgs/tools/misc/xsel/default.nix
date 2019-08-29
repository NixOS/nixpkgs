{stdenv, lib, fetchFromGitHub, libX11, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "xsel-unstable-${version}";

  version = "2018-01-10";

  src = fetchFromGitHub {
    owner = "kfish";
    repo = "xsel";
    rev = "9bfc13d64b5acb92c6648c696a9d9260fcbecc65";
    sha256 = "05ms34by5hxznnpvmvhgp6llvlkz0zw4sq6c4bgwr82lj140lscm";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libX11 ];

  meta = with lib; {
    description = "Command-line program for getting and setting the contents of the X selection";
    homepage = http://www.kfish.org/software/xsel;
    license = licenses.mit;
    maintainers = [ maintainers.cstrahan ];
    platforms = lib.platforms.unix;
  };
}
