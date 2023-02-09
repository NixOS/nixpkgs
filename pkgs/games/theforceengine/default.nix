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
  version = "1.09.100";

  src = fetchFromGitHub {
    owner = "luciusDXL";
    repo = "TheForceEngine";
    rev = "v${version}";
    sha256 = "sha256-nw9yp/StaSi5thafVT1V5YA2ZCYGWNoHUvQTpK90Foc=";
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
