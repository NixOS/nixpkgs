{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  gettext,
  fcitx5,
  libhangul,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-hangul";
  version = "5.1.5";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    hash = "sha256-+IXsMT87Dc+Ad4r6/U+NLYo+04j+I58Cqz99v4Yr0uc=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    gettext
  ];

  buildInputs = [
    fcitx5
    libhangul
  ];

  passthru.tests = {
    inherit (nixosTests) fcitx5;
  };

  meta = with lib; {
    description = "Hangul wrapper for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-hangul";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.linux;
  };
}
