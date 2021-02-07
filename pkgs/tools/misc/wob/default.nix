{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config, scdoc, wayland # wayland-scanner
, wayland-protocols, libseccomp
}:

stdenv.mkDerivation rec {
  pname = "wob";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "francma";
    repo = pname;
    rev = version;
    sha256 = "13mx6nzab6msp57s9mv9ambz53a4zkafms9v97xv5zvd6xarnrya";
  };

  nativeBuildInputs = [ meson ninja pkg-config scdoc wayland ];
  buildInputs = [ wayland-protocols ]
    ++ lib.optional stdenv.isLinux libseccomp;

  mesonFlags = lib.optional stdenv.isLinux "-Dseccomp=enabled";

  meta = with lib; {
    description = "A lightweight overlay bar for Wayland";
    longDescription = ''
      A lightweight overlay volume/backlight/progress/anything bar for Wayland,
      inspired by xob.
    '';
    inherit (src.meta) homepage;
    changelog = "https://github.com/francma/wob/releases/tag/${version}";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
