{
  mkKdeDerivation,
  fetchFromGitLab,
  qtvirtualkeyboard,
  pkg-config,
  wayland-protocols,
}:
mkKdeDerivation rec {
  pname = "plasma-keyboard";
  version = "0.1.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "plasma";
    repo = "plasma-keyboard";
    tag = "v${version}";
    hash = "sha256-Bka/tmSZIaQ6ZgWx5lCXKM8tlBUgKUy2Amv2TepdO7s=";
  };

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
