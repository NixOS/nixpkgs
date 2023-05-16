{ lib, stdenv, fetchFromSourcehut, meson, pkg-config, scdoc, ninja, libxkbcommon, wayland, wayland-scanner }:

stdenv.mkDerivation rec {
  pname = "wlrctl";
<<<<<<< HEAD
  version = "0.2.2";
=======
  version = "0.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromSourcehut {
    owner = "~brocellous";
    repo = "wlrctl";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-5mDcCSHbZMbfXbksAO4YhELznKpanse7jtbtfr09HL0=";
=======
    sha256 = "039cxc82k7x473n6d65jray90rj35qmfdmr390zy0c7ic7vn4b78";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  strictDeps = true;
  depsBuildBuild = [
    pkg-config
  ];
  nativeBuildInputs = [ meson pkg-config scdoc ninja wayland-scanner ];
  buildInputs = [ libxkbcommon wayland ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=type-limits";

  meta = with lib; {
    description = "Command line utility for miscellaneous wlroots Wayland extensions";
    homepage = "https://git.sr.ht/~brocellous/wlrctl";
    license = licenses.mit;
    maintainers = with maintainers; [ puffnfresh artturin ];
    platforms = platforms.linux;
  };
}
