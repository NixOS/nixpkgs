{ lib, stdenv, fetchFromGitHub, cmake, ncurses, zlib }:

stdenv.mkDerivation rec {
  pname = "diskscan";
  version = "0.20";

  src = fetchFromGitHub {
    owner  = "baruch";
    repo   = "diskscan";
    rev    = version;
    sha256 = "1s2df082yrnr3gqnapdsqz0yd0ld75bin37g0rms83ymzkh4ysgv";
  };

  buildInputs = [ ncurses zlib ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/baruch/diskscan";
    description = "Scan HDD/SSD for failed and near failed sectors";
    platforms = with platforms; linux;
    maintainers = with maintainers; [ peterhoeg ];
    license = licenses.gpl3;
    mainProgram = "diskscan";
  };
}
