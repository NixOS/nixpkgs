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
<<<<<<< HEAD
  version = "5.1.10";
=======
  version = "5.1.9";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-u1ZNMKSAuevW3s0WB5RovWEyewAwxMXq8NUEzuibR3U=";
=======
    hash = "sha256-ISfpS48J9gfnYTKCgfV0XQ30J/yYoX+HbyNQDIEHVdw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Extra table for Fcitx, including Boshiamy, Zhengma, Cangjie, and Quick";
    homepage = "https://github.com/fcitx/fcitx5-table-extra";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ poscat ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Extra table for Fcitx, including Boshiamy, Zhengma, Cangjie, and Quick";
    homepage = "https://github.com/fcitx/fcitx5-table-extra";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
