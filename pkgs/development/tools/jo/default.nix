{stdenv, fetchFromGitHub, autoreconfHook}:

stdenv.mkDerivation rec {
  name = "jo-${version}";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "jpmens";
    repo = "jo";

    rev = "v${version}";
    sha256="1gn9fa37mfb85dfjznyfgciibf142kp0gisc2l2pnz0zrakbvvy3";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    description = "A small utility to create JSON objects";
    homepage = https://github.com/jpmens/jo;
    license = licenses.gpl2Plus;
    maintainers = [maintainers.markus1189];
    platforms = platforms.all;
  };
}
