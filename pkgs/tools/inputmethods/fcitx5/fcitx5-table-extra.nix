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
<<<<<<< HEAD
  version = "5.1.0";
=======
  version = "5.0.13";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-os2C/6r9hz/3MEAny8Klc01cRGIiKD39rdu56kQDCnQ=";
=======
    sha256 = "sha256-/YIZMSCKJlnPL+pmUWfVf8tINKjXKkGAK7rWQ98RRjQ=";
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
    description = "Extra table for Fcitx, including Boshiamy, Zhengma, Cangjie, and Quick";
    homepage = "https://github.com/fcitx/fcitx5-table-extra";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
  };
}
