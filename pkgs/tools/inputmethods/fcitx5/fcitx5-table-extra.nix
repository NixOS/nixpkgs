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
  version = "5.0.11";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    sha256 = "sha256-tn493mSC+bvCgbKV1j+HV0Oh7n1ZufZoOccpK2i0JeY=";
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
