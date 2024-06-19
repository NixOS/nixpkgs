{ lib
, stdenv
, autoreconfHook
, fetchFromGitHub
, ncurses
, parted
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "nwipe";
  version = "0.34";

  src = fetchFromGitHub {
    owner = "martijnvanbrummelen";
    repo = "nwipe";
    rev = "v${version}";
    sha256 = "sha256-7WI8AwWkg9rOjAbOyDgCVOpeMxvJ5Bd1yvzfSv6TPLs=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    ncurses
    parted
  ];

  preConfigure = ''
    sh init.sh || :
  '';

  meta = with lib; {
    description = "Securely erase disks";
    mainProgram = "nwipe";
    homepage = "https://github.com/martijnvanbrummelen/nwipe";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ woffs ];
    platforms = platforms.linux;
  };
}
