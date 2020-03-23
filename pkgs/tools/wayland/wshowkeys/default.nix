{ stdenv, fetchurl
, meson, pkg-config, wayland, ninja
, cairo, libinput, pango, wayland-protocols, libxkbcommon
}:

let
  version = "2019-09-26";
  commit = "a9bf6bca0361b57c67e4627bf53363a7048457fd";
in stdenv.mkDerivation rec {
  pname = "wshowkeys-unstable";
  inherit version;

  src = fetchurl {
    url = "https://git.sr.ht/~sircmpwn/wshowkeys/archive/${commit}.tar.gz";
    sha256 = "0b21z3csd3v4lw5b8a6lpx5gfsdk0gjmm8906sa72hyfd1p39b7g";
  };

  nativeBuildInputs = [ meson pkg-config wayland ninja ];
  buildInputs = [ cairo libinput pango wayland-protocols libxkbcommon ];

  meta = with stdenv.lib; {
    description = "Displays keys being pressed on a Wayland session";
    longDescription = ''
      Displays keypresses on screen on supported Wayland compositors (requires
      wlr_layer_shell_v1 support).
      Note: This tool requires root permissions to read input events, but these
      permissions are dropped after startup. The NixOS module provides such a
      setuid binary (use "programs.wshowkeys.enable = true;").
    '';
    homepage = "https://git.sr.ht/~sircmpwn/wshowkeys";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
