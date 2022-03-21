{ lib, stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, fcitx5
, lua5_3
, luaPackage ? lua5_3
, gettext
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-lua";
  version = "5.0.7";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    sha256 = "sha256-ZZwPjELIJczF3AJxQqJcwA6J8vGuPdit/0dEHS+g7J0=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    fcitx5
    luaPackage
    gettext
  ];

  meta = with lib; {
    description = "Lua support for Fcitx 5";
    homepage = "https://github.com/fcitx/fcitx5-lua";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
  };
}
