{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "hdl-dump";
  version = "unstable-2021-08-20";

  src = fetchFromGitHub {
    owner = "ps2homebrew";
    repo = pname;
    rev = "1e760d7672dc12a36c09690b8c9b20d6642a2926";
    sha256 = "sha256-NMExi2pUyj8vRn9beT2YvnEogRw/xzgqE+roaZ/vNZs=";
  };

  makeFlags = [ "RELEASE=yes" ];

  installPhase = ''
    install -Dm755 hdl_dump -t $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/ps2homebrew/hdl-dump";
    description = "PlayStation 2 HDLoader image dump/install utility";
    platforms = platforms.linux;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ makefu ];
    mainProgram = "hdl_dump";
  };
}
