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
  pname = "fcitx5-table-other";
<<<<<<< HEAD
  version = "5.1.0";
=======
  version = "5.0.11";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-ymHAKaPmQckxM/XHoDOVSzEWpyQGb7zVG21CDwNfyjg=";
=======
    sha256 = "sha256-Km0c6so+Ed/lbK9t54stWjlkK70aEcf7EbQm7msPDKM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    description = "Some other tables for Fcitx";
    homepage = "https://github.com/fcitx/fcitx5-table-other";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
  };
}
