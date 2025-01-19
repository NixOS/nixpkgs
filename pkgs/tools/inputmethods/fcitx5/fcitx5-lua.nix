{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  fcitx5,
  lua,
  gettext,
}:
stdenv.mkDerivation rec {
  pname = "fcitx5-lua";
  version = "5.0.13";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    hash = "sha256-XRfYQquR9SVlYr2sX6ii8JjMyjJZWSMf1u2oKUmOhf8=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    gettext
  ];

  buildInputs = [
    fcitx5
    lua
  ];

  passthru = {
    extraLdLibraries = [ lua ];
  };

  meta = {
    description = "Lua support for Fcitx 5";
    homepage = "https://github.com/fcitx/fcitx5-lua";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ poscat ];
    platforms = lib.platforms.linux;
  };
}
