{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fcitx5,
  pkg-config,
  qtbase,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-im-emoji-picker";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "GaZaTu";
    repo = "im-emoji-picker";
    rev = "v${version}";
    hash = "sha256-ha0okJz/WEdhrNTZr5ZdbqBypS0gEnPpu7zrPfQGl78=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    fcitx5
    qtbase
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    (lib.cmakeBool "ONLY_FCITX5" true)
  ];

  preConfigure = ''
    # Remove hardcoded install prefix
    substituteInPlace CMakeLists.txt \
      --replace-fail "set(CMAKE_INSTALL_PREFIX /usr)" ""
  '';

  meta = with lib; {
    description = "Emoji picker compatible with Linux systems using either XServer or Wayland";
    homepage = "https://github.com/GaZaTu/im-emoji-picker";
    license = licenses.mit;
    maintainers = with maintainers; [ nickhu ];
    platforms = platforms.linux;
  };
}
