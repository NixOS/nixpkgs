{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  SDL2_image,
  rtaudio,
  rtmidi,
  glew,
  alsa-lib,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "theforceengine";
  version = "1.09.540";

  src = fetchFromGitHub {
    owner = "luciusDXL";
    repo = "TheForceEngine";
    rev = "v${version}";
    sha256 = "sha256-s54X6LZdk7daIlQPHyRBxc8MLS6bzkkypi4m1m+xK80=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2
    SDL2_image
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
    description = "Modern \"Jedi Engine\" replacement supporting Dark Forces, mods, and in the future, Outlaws";
    mainProgram = "theforceengine";
    homepage = "https://theforceengine.github.io";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ devusb ];
    platforms = [ "x86_64-linux" ];
  };
}
