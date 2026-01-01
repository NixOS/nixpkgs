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
  pname = "fcitx5-table-other";
  version = "5.1.5";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    hash = "sha256-hoAaismWfiVIYs780oiwwA3syjBnYNQ5nYbhlBbAAKw=";
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
    description = "Some other tables for Fcitx";
    homepage = "https://github.com/fcitx/fcitx5-table-other";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ poscat ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Some other tables for Fcitx";
    homepage = "https://github.com/fcitx/fcitx5-table-other";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
