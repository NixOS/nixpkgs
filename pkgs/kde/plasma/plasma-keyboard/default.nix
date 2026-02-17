{
  mkKdeDerivation,
  pkg-config,
  qtvirtualkeyboard,
  wayland-protocols,
}:
mkKdeDerivation {
  pname = "plasma-keyboard";

  extraNativeBuildInputs = [
    pkg-config
  ];

  extraBuildInputs = [
    qtvirtualkeyboard
    wayland-protocols
  ];

  qtWrapperArgs = [
    # FIXME: fix this upstream? This should probably be XDG_DATA_DIRS
    "--set QT_VIRTUALKEYBOARD_HUNSPELL_DATA_PATH /run/current-system/sw/share/hunspell/"
  ];
}
