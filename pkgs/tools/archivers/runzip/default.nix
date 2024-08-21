{ lib, stdenv, fetchFromGitHub, libzip, libiconv, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "1.4";
  pname = "runzip";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libiconv libzip ];

  src = fetchFromGitHub {
    owner = "vlm";
    repo = "zip-fix-filename-encoding";
    rev = "v${version}";
    sha256 = "0l5zbb5hswxczigvyal877j0aiq3fc01j3gv88bvy7ikyvw3lc07";
  };

  meta = {
    description = "Tool to convert filename encoding inside a ZIP archive";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.unix;
    mainProgram = "runzip";
  };
}
