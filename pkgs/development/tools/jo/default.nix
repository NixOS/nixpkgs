{stdenv, fetchFromGitHub, autoreconfHook}:

stdenv.mkDerivation rec {
  name = "jo-${version}";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "jpmens";
    repo = "jo";

    rev = "v${version}";
    sha256="0vyi0aaxsp6x3cvym7mlcfdsxjhj5h0b00mqc42mg8kc95cyp2c1";
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
