{lib, stdenv, fetchFromGitHub, autoreconfHook, pandoc, pkg-config}:

stdenv.mkDerivation rec {
  pname = "jo";
  version = "1.9";

  src = fetchFromGitHub {
    owner  = "jpmens";
    repo = "jo";
    rev = version;
    sha256 ="sha256-1q4/RpxfoAdtY3m8bBuj7bhD17V+4dYo3Vb8zMbI1YU=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook pandoc pkg-config ];

  meta = with lib; {
    description = "A small utility to create JSON objects";
    homepage = "https://github.com/jpmens/jo";
    mainProgram = "jo";
    license = licenses.gpl2Plus;
    maintainers = [maintainers.markus1189];
    platforms = platforms.all;
  };
}
