{ lib, stdenv, fetchgit, cmake, sfml, libGLU, libGL, bullet, glm, libmad, xlibsWrapper, openal
, SDL2, boost, ffmpeg_3, Cocoa, OpenAL }:

stdenv.mkDerivation {
  version = "2019-10-26";
  pname = "openrw";

  src = fetchgit {
    url = "https://github.com/rwengine/openrw";
    rev = "51b7264744d1aaa20de3b86a7a4e92a9930881ba";
    sha256 = "04s088wfxkfmb4dxdvad611yxj8smxlnxdm5xy81zldfzybvx8dg";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    sfml libGLU libGL bullet glm libmad xlibsWrapper openal SDL2 boost ffmpeg_3
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
  };
}
