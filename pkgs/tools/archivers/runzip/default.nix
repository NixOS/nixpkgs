{ lib, stdenv, fetchFromGitHub, libzip, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "1.4";
  pname = "runzip";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libzip ];

  src = fetchFromGitHub {
    owner = "vlm";
    repo = "zip-fix-filename-encoding";
    rev = "v${version}";
    sha256 = "0l5zbb5hswxczigvyal877j0aiq3fc01j3gv88bvy7ikyvw3lc07";
  };

  meta = {
    description = "A tool to convert filename encoding inside a ZIP archive";
    license = lib.licenses.bsd2 ;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.linux;
  };
}
