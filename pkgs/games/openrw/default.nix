{ stdenv, fetchgit, cmake, sfml, libGLU_combined, bullet, glm, libmad, x11, openal
, SDL2, boost, ffmpeg }:

stdenv.mkDerivation rec {
  version = "2017-09-17";
  name = "openrw-${version}";

  src = fetchgit {
    url = "https://github.com/rwengine/openrw";
    rev = "11e90c61e56b60240251cd080f175ddff7d7a101";
    sha256 = "16qklk9yc4ssxxkicxvww4gmg1c7cm6vhyilyv287vhz1fq9sz49";
    fetchSubmodules = true;
  };

  buildInputs = [
    cmake sfml libGLU_combined bullet glm libmad x11 openal SDL2 boost ffmpeg
  ];

  meta = with stdenv.lib; {
    description = "Unofficial open source recreation of the classic Grand Theft Auto III game executable";
    homepage = https://github.com/rwengine/openrw;
    license = licenses.gpl3;
    longDescription = ''
      OpenRW is an open source re-implementation of Rockstar Games' Grand Theft
      Auto III, a classic 3D action game first published in 2001.
    '';
    maintainers = with maintainers; [ kragniz ];
    platforms = platforms.all;
  };
}
