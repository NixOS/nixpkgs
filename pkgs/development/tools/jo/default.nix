{stdenv, fetchFromGitHub, autoreconfHook}:

stdenv.mkDerivation rec {
  pname = "jo";
  version = "1.2";

  src = fetchFromGitHub {
    owner  = "jpmens";
    repo = "jo";
    rev = version;
    sha256 ="03b22zb5034ccqyp4ynfzknxagb3jz2dppl0kqz2nv4a08aglpmy";
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
