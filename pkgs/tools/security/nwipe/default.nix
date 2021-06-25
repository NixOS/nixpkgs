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
  version = "0.31";

  src = fetchFromGitHub {
    owner = "martijnvanbrummelen";
    repo = "nwipe";
    rev = "v${version}";
    sha256 = "sha256-+xwQLjl0jhven6udfCprRKW8qWM6JMh5MOZ+ZdaJWQg=";
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
