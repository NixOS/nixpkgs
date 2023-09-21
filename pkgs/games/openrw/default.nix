{ lib
, stdenv
, fetchFromGitHub
, cmake
, sfml
, libGLU
, libGL
, bullet
, glm
, libmad
, openal
, SDL2
, boost
, ffmpeg_4
, Cocoa
, OpenAL }:

stdenv.mkDerivation {
  version = "unstable-2021-10-14";
  pname = "openrw";

  src = fetchFromGitHub {
    owner = "rwengine";
    repo = "openrw";
    rev = "0f83c16f6518c427a4f156497c3edc843610c402";
    sha256 = "0i6nx9g0xb8sziak5swi8636fszcjjx8n2jwgz570izw2fl698ff";
    fetchSubmodules = true;
  };

  postPatch = lib.optional (stdenv.cc.isClang && (lib.versionAtLeast stdenv.cc.version "9"))''
    substituteInPlace cmake_configure.cmake \
      --replace 'target_link_libraries(rw_interface INTERFACE "stdc++fs")' ""
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    sfml libGLU libGL bullet glm libmad openal SDL2 boost ffmpeg_4
  ] ++ lib.optionals stdenv.isDarwin [ OpenAL Cocoa ];

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
