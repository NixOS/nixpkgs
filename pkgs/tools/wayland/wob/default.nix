{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, scdoc
, wayland-scanner
, wayland
, wayland-protocols
, libseccomp
}:

stdenv.mkDerivation rec {
  pname = "wob";
  version = "0.13";

  src = fetchFromGitHub {
    owner = "francma";
    repo = pname;
    rev = version;
    sha256 = "sha256-CXRBNnnhNV5LBIasVtmGrRG4ZXFGC7qNInU7Y0QsHbs=";
  };

  strictDeps = true;
  depsBuildBuild = [
    pkg-config
  ];
  nativeBuildInputs = [ meson ninja pkg-config scdoc wayland-scanner ];
  buildInputs = [ wayland wayland-protocols ]
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
    platforms = platforms.unix;
  };
}
