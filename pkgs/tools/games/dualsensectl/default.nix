{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, dbus
, hidapi
, udev
}:

stdenv.mkDerivation rec {
  pname = "dualsensectl";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "nowrep";
    repo = "dualsensectl";
    rev = "v${version}";
    hash = "sha256-DrPVzbaLO2NgjNcEFyCs2W+dlbdpBeRX1ZfFenqz7IY=";
  };

  postPatch = ''
    substituteInPlace Makefile --replace "/usr/" "/"
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
    hidapi
    udev
  ];

  makeFlags = [
    "DESTDIR=$(out)"
  ];

  meta = with lib; {
    description = "Linux tool for controlling PS5 DualSense controller";
    homepage = "https://github.com/nowrep/dualsensectl";
    license = licenses.gpl2Only;
    mainProgram = "dualsensectl";
    maintainers = with maintainers; [ azuwis ];
    platforms = platforms.linux;
  };
}
