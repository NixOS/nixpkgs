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
  version = "1.10";

  src = fetchFromGitHub {
    owner = "resurrecting-open-source-projects";
    repo = pname;
    rev = version;
    sha256 = "sha256-ypPUQt3N30qUw5ecVRhwz3Hnh9lTOnbAm7o5tdxjyds=";
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
    description = "A command-line screen capture utility";
    platforms = platforms.linux;
    maintainers = with maintainers; [ globin ];
    license = licenses.mitAdvertising;
  };
}
