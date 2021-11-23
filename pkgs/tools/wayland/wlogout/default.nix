{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, meson
, ninja
, scdoc
, gtk3
, libxkbcommon
, wayland
, wayland-protocols
, gtk-layer-shell
# gtk-layer-shell fails to cross-compile due to a hard dependency
# on gobject-introspection.
# Disable it when cross-compiling since it's an optional dependency.
# This disables transparency support.
, withGtkLayerShell ? (stdenv.buildPlatform == stdenv.hostPlatform)
}:

stdenv.mkDerivation rec {
  pname = "wlogout";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "ArtsyMacaw";
    repo = "wlogout";
    rev = version;
    sha256 = "cTscfx+erHVFHwwYpN7pADQWt5sq75sQSyXSP/H8kOs=";
  };

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [ pkg-config meson ninja scdoc ];
  buildInputs = [
    gtk3
    libxkbcommon
    wayland
    wayland-protocols
  ] ++ lib.optionals withGtkLayerShell [
    gtk-layer-shell
  ];

  postPatch = ''
    substituteInPlace style.css \
      --replace "/usr/share/wlogout" "$out/share/${pname}"

    substituteInPlace main.c \
      --replace "/etc/wlogout" "$out/etc/${pname}"
  '';

  mesonFlags = [
    "--datadir=${placeholder "out"}/share"
    "--sysconfdir=${placeholder "out"}/etc"
  ];

  meta = with lib; {
    homepage = "https://github.com/ArtsyMacaw/wlogout";
    description = "A wayland based logout menu";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
# TODO: shell completions
