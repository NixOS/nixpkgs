{ lib, stdenv, fetchFromSourcehut
, meson, pkg-config, ninja, wayland-scanner, scdoc
, wayland, wayland-protocols
}:

stdenv.mkDerivation rec {
  pname = "wlsunset";
<<<<<<< HEAD
  version = "0.3.0";
=======
  version = "0.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-jGYPWaRUqDL4htdAOA9CAQfoHLBPvK7O9vAzcE81f/E=";
=======
    sha256 = "0hhsddh3rs066rbsjksr8kcwg8lvglbvs67dq0r5wx5c1xcwb51w";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
