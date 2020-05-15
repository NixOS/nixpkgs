{ stdenv, fetchFromGitHub, autoreconfHook
, freeimage, libGL }:

stdenv.mkDerivation rec {
  version = "1.0.2";
  pname = "gamecube-tools";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ freeimage libGL ];

  src = fetchFromGitHub {
    owner = "devkitPro";
    repo  = "gamecube-tools";
    rev = "v${version}";
    sha256 = "0zvpkzqvl8iv4ndzhkjkmrzpampyzgb91spv0h2x2arl8zy4z7ca";
  };

  meta = with stdenv.lib; {
    description = "Tools for gamecube/wii projects";
    homepage = "https://github.com/devkitPro/gamecube-tools/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ tomsmeets ];
  };
}
