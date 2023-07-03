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
  version = "0.3";

  src = fetchFromGitHub {
    owner = "nowrep";
    repo = "dualsensectl";
    rev = "v${version}";
    hash = "sha256-OZmZ+ENBBKzRZ9jLIn9Bz7oGYrSAjZ5XlOR9fpN0cZs=";
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
    maintainers = with maintainers; [ azuwis ];
    platforms = platforms.linux;
  };
}
