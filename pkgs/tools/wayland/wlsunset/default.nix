{ lib, stdenv, fetchFromSourcehut
, meson, pkg-config, ninja, wayland-scanner, scdoc
, wayland, wayland-protocols
}:

stdenv.mkDerivation rec {
  pname = "wlsunset";
  version = "0.2.0";

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = pname;
    rev = version;
    sha256 = "0hhsddh3rs066rbsjksr8kcwg8lvglbvs67dq0r5wx5c1xcwb51w";
  };

  strictDeps = true;
  depsBuildBuild = [
    pkg-config
  ];
  nativeBuildInputs = [ meson pkg-config ninja wayland-scanner scdoc ];
  buildInputs = [ wayland wayland-protocols ];

  meta = with lib; {
    description = "Day/night gamma adjustments for Wayland";
    longDescription = ''
      Day/night gamma adjustments for Wayland compositors supporting
      wlr-gamma-control-unstable-v1.
    '';
    homepage = "https://sr.ht/~kennylevinsen/wlsunset/";
    changelog = "https://git.sr.ht/~kennylevinsen/wlsunset/refs/${version}";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
