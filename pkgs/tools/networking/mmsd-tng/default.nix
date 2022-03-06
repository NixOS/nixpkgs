{ stdenv
, lib
, fetchFromGitLab
, meson
, pkg-config
, ninja
, dbus
, glib
, modemmanager
, libsoup
, c-ares
, protobuf
, libphonenumber
, mobile-broadband-provider-info
}:

stdenv.mkDerivation rec {
  pname = "mmsd-tng";
  version = "1.9";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "kop316";
    repo = "mmsd";
    rev = version;
    sha256 = "1l2wy4fg4k9rh4wbsa0m9nzwckfabinqxwzr1bl0478azd9wrb90";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];

  buildInputs = [
    dbus
    glib
    modemmanager
    libsoup
    c-ares
    protobuf
    libphonenumber
    mobile-broadband-provider-info
  ];

  meta = with lib; {
    description = "Transmits and receives MMMSes through ModemManager";
    homepage = "https://gitlab.com/kop316/mmsd";
    license = with licenses; [ gpl2Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ noneucat ];
  };
}
