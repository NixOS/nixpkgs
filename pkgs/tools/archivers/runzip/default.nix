{ stdenv, fetchFromGitHub, libzip, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "1.4";
  name = "runzip-${version}";

  buildInputs = [ libzip autoreconfHook ];

  src = fetchFromGitHub {
    owner = "vlm";
    repo = "zip-fix-filename-encoding";
    rev = "v${version}";
    sha256 = "0l5zbb5hswxczigvyal877j0aiq3fc01j3gv88bvy7ikyvw3lc07";
  };

  meta = {
    description = "A tool to convert filename encoding inside a ZIP archive";
    license = stdenv.lib.licenses.bsd2 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
