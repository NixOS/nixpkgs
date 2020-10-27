{ stdenv, fetchurl
, meson, pkg-config, wayland, ninja
, cairo, libinput, pango, wayland-protocols, libxkbcommon
}:

let
  version = "2020-03-29";
  commit = "6388a49e0f431d6d5fcbd152b8ae4fa8e87884ee";
in stdenv.mkDerivation rec {
  pname = "wshowkeys-unstable";
  inherit version;

  src = fetchurl {
    url = "https://git.sr.ht/~sircmpwn/wshowkeys/archive/${commit}.tar.gz";
    sha256 = "0iplmw13jmc8d3m307kc047zq8yqwm42kw9fpm270562i3p0qk4d";
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
    license = with licenses; [ gpl3Only mit ];
    # Some portions of the code are taken from Sway which is MIT licensed.
    # TODO: gpl3Only or gpl3Plus (ask upstream)?
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos berbiche ];
  };
}
