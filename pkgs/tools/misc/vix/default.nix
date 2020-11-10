{ stdenv, fetchFromGitHub, autoreconfHook, SDL }:

stdenv.mkDerivation {
  pname = "vix";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "BatchDrake";
    repo = "vix";
    rev = "824b6755157a0f7430a0be0af454487d1492204d";
    sha256 = "1y0a2sajkrsg36px21b8lgx1irf0pyj7hccyd6k806bm4zhgxw1z";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ SDL ];

  meta = with stdenv.lib; {
    description = "Visual Interface heXadecimal dump ";
    homepage = "http://actinid.org/vix/";
    license = licenses.gpl3;
    maintainers = [ maintainers.ehmry ];
  };
}
