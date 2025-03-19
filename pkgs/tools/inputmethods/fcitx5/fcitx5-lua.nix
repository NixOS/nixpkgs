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
  version = "5.0.14";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    hash = "sha256-7FBUOsaKr9cuEaqd4dqnAGL5sd3RF+qV6GEkOUQ1/k4=";
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

  meta = with lib; {
    description = "Lua support for Fcitx 5";
    homepage = "https://github.com/fcitx/fcitx5-lua";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
  };
}
