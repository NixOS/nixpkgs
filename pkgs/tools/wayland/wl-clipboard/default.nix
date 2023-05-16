{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wayland
, wayland-protocols
, wayland-scanner
}:

stdenv.mkDerivation rec {
  pname = "wl-clipboard";
<<<<<<< HEAD
  version = "2.2.1";
=======
  version = "2.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "bugaevc";
    repo = "wl-clipboard";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-BYRXqVpGt9FrEBYQpi2kHPSZyeMk9o1SXkxjjcduhiY=";
=======
    sha256 = "sha256-lqtLHLsSChWcYWsfFigj0Xveo9doAr7G31fRSaxm0Lw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  strictDeps = true;
  nativeBuildInputs = [ meson ninja pkg-config wayland-scanner ];
  buildInputs = [ wayland wayland-protocols ];

  mesonFlags = [
    "-Dfishcompletiondir=share/fish/vendor_completions.d"
  ];

  meta = with lib; {
    homepage = "https://github.com/bugaevc/wl-clipboard";
    description = "Command-line copy/paste utilities for Wayland";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.unix;
  };
}
