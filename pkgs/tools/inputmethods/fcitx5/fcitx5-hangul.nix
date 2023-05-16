{ lib
, stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, gettext
, fcitx5
, libhangul
<<<<<<< HEAD
, nixosTests
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-hangul";
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
    sha256 = "sha256-3cJLF80oAqGSJvPPyKcHxaWysA9RtWYGgptailYd4dk=";
=======
    sha256 = "sha256-VA9LDGMJRJDDCxIsx7wpDgdc2V9cuWlydAq5yiIvpxA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  passthru.tests = {
    inherit (nixosTests) fcitx5;
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Hangul wrapper for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-hangul";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.linux;
  };
}
