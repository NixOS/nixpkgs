{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config, scdoc, wayland # wayland-scanner
, wayland-protocols, libseccomp
}:

stdenv.mkDerivation rec {
  pname = "wob";
  version = "0.10";

  src = fetchFromGitHub {
    owner = "francma";
    repo = pname;
    rev = version;
    sha256 = "0v7xm8zd9237v5j5h79pd0x6dkal5fgg1ly9knssjpv3hswwyv40";
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
