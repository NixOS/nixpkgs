{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  fcitx5,
  fcitx5-qt,
  gettext,
  qtbase,
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-unikey";
<<<<<<< HEAD
  version = "5.1.9";
=======
  version = "5.1.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "fcitx5-unikey";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-tTJPoFmhILPvKNwut0vLohkvm+nJzX8VrMVTopfmF1Q=";
=======
    hash = "sha256-Yeyk6c4bjsxTi8DvRBGip/gayKaOvO6R5PGYkc0uUdk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    gettext # msgfmt
  ];

  buildInputs = [
    qtbase
    fcitx5
    fcitx5-qt
  ];

  dontWrapQtApps = true;

<<<<<<< HEAD
  meta = {
    description = "Unikey engine support for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-unikey";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ berberman ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Unikey engine support for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-unikey";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ berberman ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
