{ lib
, stdenv
, fetchFromGitHub
, imlib2
, autoreconfHook
, autoconf-archive
, libX11
, libXext
, libXfixes
, libXcomposite
, libXinerama
, pkg-config
, libbsd
}:

stdenv.mkDerivation rec {
  pname = "scrot";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "resurrecting-open-source-projects";
    repo = pname;
    rev = version;
    sha256 = "sha256-MUmvzZMzzKKw5GjOUhpdrMIgKO9/i9RDqDtTsSghd18=";
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
  ];

  buildInputs = [
    imlib2
    libX11
    libXext
    libXfixes
    libXcomposite
    libXinerama
    libbsd
  ];

  meta = with lib; {
    homepage = "https://github.com/resurrecting-open-source-projects/scrot";
    description = "Command-line screen capture utility";
    mainProgram = "scrot";
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
    license = licenses.mitAdvertising;
  };
}
