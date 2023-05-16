{ lib, stdenv, fetchFromGitHub }:

## Usage
# In NixOS, simply add this package to services.udev.packages:
#   services.udev.packages = [ pkgs.android-udev-rules ];

stdenv.mkDerivation rec {
  pname = "android-udev-rules";
<<<<<<< HEAD
  version = "20230614";
=======
  version = "20230303";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "M0Rf30";
    repo = "android-udev-rules";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-TLQHZYcnO7VzIHH+aCj78plTwK5RrcsU/OfNXApAvdM=";
=======
    sha256 = "sha256-ddalOVt0gLuTcwk322fNNn6WNZx1Ubsa4MgaG0Lmn2k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  installPhase = ''
    runHook preInstall
    install -D 51-android.rules $out/lib/udev/rules.d/51-android.rules
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/M0Rf30/android-udev-rules";
    description = "Android udev rules list aimed to be the most comprehensive on the net";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ abbradar ];
  };
}
