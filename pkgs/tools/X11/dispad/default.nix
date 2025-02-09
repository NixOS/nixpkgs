{ lib, stdenv, fetchFromGitHub, libX11, libXi, libconfuse }:

stdenv.mkDerivation rec {
  pname = "dispad";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "BlueDragonX";
    repo = "dispad";
    rev = "v${version}";
    sha256 = "0y0n9mf1hs3s706gkpmg1lh74m6vvkqc9rdbzgc6s2k7vdl2zp1y";
  };

  buildInputs = [ libX11 libXi libconfuse ];

  meta = with lib; {
    description = "A small daemon for disabling trackpads while typing";
    homepage = "https://github.com/BlueDragonX/dispad";
    license = licenses.gpl2;
    maintainers = with maintainers; [ zimbatm ];
    platforms = platforms.linux;
    mainProgram = "dispad";
  };
}
