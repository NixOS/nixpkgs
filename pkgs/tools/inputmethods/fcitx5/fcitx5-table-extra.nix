{ lib, stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, gettext
, libime
, boost
, fcitx5
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-table-extra";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "fcitx5-table-extra";
    rev = version;
    sha256 = "UHhiWm2Khh6JBB9jz0ZKFofkAJPlqn6SqHeK9etoaxs=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    gettext
    libime
    boost
    fcitx5
  ];

  meta = with lib; {
    description = "Extra table for Fcitx, including Boshiamy, Zhengma, Cangjie, and Quick";
    homepage = "https://github.com/fcitx/fcitx5-table-extra";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
  };
}
