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
  version = "5.1.8";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    hash = "sha256-FrVkSDLH6lYQbhvcxtX/IQpRC3dphsHu7xVdgnDNcgg=";
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
