{ lib
, stdenv
, fetchFromGitHub
, libnl
, ncurses
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "wavemon";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "uoaerg";
    repo = "wavemon";
    rev = "v${version}";
    sha256 = "0s3yz15vzx90fxyb8bgryksn0cr2gpz9inbcx4qjrgs7zfbm4pgh";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libnl
    ncurses
  ];

  meta = with lib; {
    description = "Ncurses-based monitoring application for wireless network devices";
    homepage = "https://github.com/uoaerg/wavemon";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ raskin fpletz ];
    platforms = platforms.linux;
  };
}
