{ lib, stdenv, fetchFromSourcehut
, meson, pkg-config, wayland-scanner, ninja
, cairo, libinput, pango, wayland, wayland-protocols, libxkbcommon
}:

let
  version = "2020-03-29";
  commit = "6388a49e0f431d6d5fcbd152b8ae4fa8e87884ee";
in stdenv.mkDerivation rec {
  pname = "wshowkeys-unstable";
  inherit version;

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "wshowkeys";
    rev = commit;
    sha256 = "10kafdja5cwbypspwhvaxjz3hvf51vqjzbgdasl977193cvxgmbs";
  };

  nativeBuildInputs = [ meson pkg-config wayland-scanner ninja ];
  buildInputs = [ cairo libinput pango wayland wayland-protocols libxkbcommon ];

  meta = with lib; {
    description = "Displays keys being pressed on a Wayland session";
    longDescription = ''
      Displays keypresses on screen on supported Wayland compositors (requires
      wlr_layer_shell_v1 support).
      Note: This tool requires root permissions to read input events, but these
      permissions are dropped after startup. The NixOS module provides such a
      setuid binary (use "programs.wshowkeys.enable = true;").
    '';
    homepage = "https://git.sr.ht/~sircmpwn/wshowkeys";
    license = with licenses; [ gpl3Only mit ];
    # Some portions of the code are taken from Sway which is MIT licensed.
    # TODO: gpl3Only or gpl3Plus (ask upstream)?
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos berbiche ];
    broken = true; # Unmaintained and fails to run (Wayland protocol error)
    # TODO (@primeos): Remove this package after the NixOS 21.11 branch-off
  };
}
