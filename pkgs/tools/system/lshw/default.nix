{ stdenv
, lib
, fetchFromGitHub
, hwdata
, gtk2
, pkg-config
, sqlite # compile GUI
, withGUI ? false
}:

stdenv.mkDerivation rec {
  pname = "lshw";
  version = "B.02.19";

  src = fetchFromGitHub {
    owner = "lyonel";
    repo = pname;
    rev = version;
    sha256 = "sha256-PzbNGc1pPiPLWWgTeWoNfAo+SsXgi1HcjnXfYXA9S0I=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ hwdata ]
    ++ lib.optionals withGUI [ gtk2 sqlite ];

  makeFlags = [
    "PREFIX=$(out)"
    "VERSION=${version}"
  ];

  buildFlags = [ "all" ] ++ lib.optional withGUI "gui";

  installTargets = [ "install" ] ++ lib.optional withGUI "install-gui";

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://ezix.org/project/wiki/HardwareLiSter";
    description = "Provide detailed information on the hardware configuration of the machine";
    license = licenses.gpl2;
    maintainers = with maintainers; [ thiagokokada ];
    platforms = platforms.linux;
  };
}
