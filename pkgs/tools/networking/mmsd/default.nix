{ lib, stdenv
, fetchgit
, autoreconfHook
, pkg-config
, glib
, dbus
}:

stdenv.mkDerivation rec {
  pname = "mmsd";
  version = "unstable-2019-07-15";

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/network/ofono/mmsd.git";
    rev = "f4b8b32477a411180be1823fdc460b4f7e1e3c9c";
    sha256 = "0hcnpyhsi7b5m825dhnwbp65yi0961wi8mipzdvaw5nc693xv15b";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    glib
    dbus
  ];

  doCheck = true;

  meta = with lib; {
    description = "Multimedia Messaging Service Daemon";
    homepage = "https://01.org/ofono";
    license = licenses.gpl2;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
