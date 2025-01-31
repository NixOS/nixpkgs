{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, sfml
, libGLU
, libGL
, bullet
, glm
, libmad
, openal
, SDL2
, boost
, ffmpeg_6
, Cocoa
, OpenAL }:

stdenv.mkDerivation {
  version = "0-unstable-2024-04-20";
  pname = "openrw";

  src = fetchFromGitHub {
    owner = "rwengine";
    repo = "openrw";
    rev = "f10a5a8f7abc79a0728847e9a10ee104a1216047";
    hash = "sha256-4ydwPh/pCzuZNNOyZuEEeX4wzI+dqTtAxUyXOXz76zk=";
    fetchSubmodules = true;
  };

  patches = [
    # SoundSource.cpp: return AVERROR_EOF when buffer is empty
    # https://github.com/rwengine/openrw/pull/747
    ./fix-ffmpeg-6.patch
  ];

  postPatch = lib.optional (stdenv.cc.isClang && (lib.versionAtLeast stdenv.cc.version "9"))''
    substituteInPlace cmake_configure.cmake \
      --replace 'target_link_libraries(rw_interface INTERFACE "stdc++fs")' ""
  '';

  nativeBuildInputs = [ cmake ninja ];

  buildInputs = [
    sfml libGLU libGL bullet glm libmad openal SDL2 boost ffmpeg_6
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ OpenAL Cocoa ];

  meta = with lib; {
    description = "Unofficial open source recreation of the classic Grand Theft Auto III game executable";
    homepage = "https://github.com/rwengine/openrw";
    license = licenses.gpl3;
    longDescription = ''
      OpenRW is an open source re-implementation of Rockstar Games' Grand Theft
      Auto III, a classic 3D action game first published in 2001.
    '';
    maintainers = with maintainers; [ kragniz ];
    platforms = platforms.all;
    mainProgram = "rwgame";
  };
}
