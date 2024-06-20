{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, glib
, cairo
, wayland
, libGL
}:

let
  libdeps = [ wayland.dev libGL.dev glib.dev cairo.dev ];
in

rustPlatform.buildRustPackage rec {
  pname = "enkei";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "jwuensche";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-COU2JtiJcPRA3Jno0qLEIVgimYBWfn5Pgc1OMImsJtI=";
  };

  nativeBuildInputs = [
    pkg-config
  ] ++ libdeps;

  buildInputs = [ wayland libGL glib cairo ];

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    rm Cargo.lock
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  meta = with lib; {
    description = "Wallpaper daemon and control tool for Wayland";
    longDescription = ''
      Created to allow displaying dynamic wallpapers based on the specification format used for example in the `Gnome` desktop environment.
      It is designed to offer a _smooth_ transition between wallpapers and gradual change over long and short periods of time.
      For a fast handling `enkei` uses `OpenGL` to render images and blending them for transitions.
    '';
    homepage = "https://github.com/jwuensche/enkei";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ppenguin ];
  };
}
