{ lib, stdenv, fetchFromGitHub, autoreconfHook, libX11 }:

stdenv.mkDerivation rec {
  pname = "xrectsel";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "ropery";
    repo = "xrectsel";
    rev = version;
    sha256 = "0prl4ky3xzch6xcb673mcixk998d40ngim5dqc5374b1ls2r6n7l";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libX11 ];

  meta = with lib; {
    description = "Print the geometry of a rectangular screen region";
    homepage = "https://github.com/ropery/xrectsel";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.linux;
    mainProgram = "xrectsel";
  };
}
