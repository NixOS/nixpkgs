{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  gettext,
  libime,
  boost,
  fcitx5,
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-table-extra";
  version = "5.1.7";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    hash = "sha256-3Er01Qj3XEIO36xTQrBISzxMaIO4j8uqPe7+w9uk3UM=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    gettext
    libime
    fcitx5
  ];

  buildInputs = [
    boost
  ];

  meta = with lib; {
    description = "Extra table for Fcitx, including Boshiamy, Zhengma, Cangjie, and Quick";
    homepage = "https://github.com/fcitx/fcitx5-table-extra";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
  };
}
