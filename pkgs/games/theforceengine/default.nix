{ lib
, stdenv
, fetchFromGitHub
, SDL2
, libdevil
, rtaudio
, rtmidi
, glew
, alsa-lib
, cmake
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "theforceengine";
<<<<<<< HEAD
  version = "1.09.300";
=======
  version = "1.09.100";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "luciusDXL";
    repo = "TheForceEngine";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-nf5fhP68AgBESiJleeZOLXkAajS+JmHUqyj4vAt2wl4=";
=======
    sha256 = "sha256-nw9yp/StaSi5thafVT1V5YA2ZCYGWNoHUvQTpK90Foc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2
    libdevil
    rtaudio
    rtmidi
    glew
    alsa-lib
  ];

  prePatch = ''
    # use nix store path instead of hardcoded /usr/share for support data
    substituteInPlace TheForceEngine/TFE_FileSystem/paths-posix.cpp \
      --replace "/usr/share" "$out/share"
  '';

  meta = with lib; {
    description = "Modern \"Jedi Engine\" replacement supporting Dark Forces, mods, and in the future Outlaws.";
    homepage = "https://theforceengine.github.io";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ devusb ];
    platforms = [ "x86_64-linux" ];
  };
}
