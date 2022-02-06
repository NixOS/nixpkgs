{ lib
, stdenv
, fetchFromGitHub
, imlib2
, xlibsWrapper
, autoreconfHook
, autoconf-archive
, libXfixes
, libXcomposite
, pkg-config
, libbsd
}:

stdenv.mkDerivation rec {
  pname = "scrot";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "resurrecting-open-source-projects";
    repo = pname;
    rev = version;
    sha256 = "sha256-oVmEPkEK1xDcIRUQjCp6CKf+aKnnVe3L7aRTdSsCmmY=";
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
  ];

  buildInputs = [
    imlib2
    xlibsWrapper
    libXfixes
    libXcomposite
    libbsd
  ];

  meta = with lib; {
    homepage = "https://github.com/resurrecting-open-source-projects/scrot";
    description = "A command-line screen capture utility";
    platforms = platforms.linux;
    maintainers = with maintainers; [ globin ];
    license = licenses.mit;
  };
}
