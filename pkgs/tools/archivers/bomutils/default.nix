{ lib, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "bomutils";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "hogliux";
    repo = pname;
    rev = version;
    sha256 = "1i7nhbq1fcbrjwfg64znz8p4l7662f7qz2l6xcvwd5z93dnmgmdr";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/hogliux/bomutils";
    description = "Open source tools to create bill-of-materials files used in macOS installers";
    platforms = platforms.all;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ prusnak ];
  };
}
