{ lib
, stdenv
, fetchFromGitHub
, inih
, meson
, ninja
, pkg-config
, cmocka
, scdoc
, wayland-scanner
, wayland
, wayland-protocols
, libseccomp
}:

stdenv.mkDerivation rec {
  pname = "wob";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "francma";
    repo = pname;
    rev = version;
    sha256 = "sha256-9LFAEo17w861ldMJU+t1oLAKoM6gJc4Em4tSwQDXbKU=";
  };

  strictDeps = true;
  depsBuildBuild = [
    pkg-config
  ];
  nativeBuildInputs = [ meson ninja pkg-config scdoc wayland-scanner ];
  buildInputs = [ cmocka inih wayland wayland-protocols ]
    ++ lib.optional stdenv.isLinux libseccomp;

  mesonFlags = lib.optional stdenv.isLinux "-Dseccomp=enabled";

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A lightweight overlay bar for Wayland";
    longDescription = ''
      A lightweight overlay volume/backlight/progress/anything bar for Wayland,
      inspired by xob.
    '';
    changelog = "https://github.com/francma/wob/releases/tag/${version}";
    license = licenses.isc;
    maintainers = with maintainers; [ primeos ];
    platforms = platforms.linux;
    mainProgram = "wob";
  };
}
