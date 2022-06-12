{lib, stdenv, fetchFromGitHub, autoreconfHook, pandoc, pkg-config}:

stdenv.mkDerivation rec {
  pname = "jo";
  version = "1.6";

  src = fetchFromGitHub {
    owner  = "jpmens";
    repo = "jo";
    rev = version;
    sha256 ="sha256-aATCeJV0x+XHOQbwulutxivPzGVQ0mJj90vA+6IM124=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook pandoc pkg-config ];

  meta = with lib; {
    description = "A small utility to create JSON objects";
    homepage = "https://github.com/jpmens/jo";
    license = licenses.gpl2Plus;
    maintainers = [maintainers.markus1189];
    platforms = platforms.all;
  };
}
