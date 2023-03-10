{ lib
, stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, gettext
, fcitx5
, libchewing
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-chewing";
  version = "5.0.13";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    sha256 = "sha256-bYkIf2TFwRzfl0tYeq6rZUETz3lbT1LEaUAuG7d35yU=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    gettext
  ];

  buildInputs = [
    fcitx5
    libchewing
  ];

  meta = with lib; {
    description = "Chewing wrapper for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-chewing";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.linux;
  };
}
