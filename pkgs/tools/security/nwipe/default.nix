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
  version = "0.32";

  src = fetchFromGitHub {
    owner = "martijnvanbrummelen";
    repo = "nwipe";
    rev = "v${version}";
    sha256 = "sha256-O3kYiai+5KMHWd2om4+HrTIw9lB2wLJF3Mrr6iY2+I8=";
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
    homepage = "https://github.com/martijnvanbrummelen/nwipe";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ woffs ];
    platforms = platforms.linux;
  };
}
