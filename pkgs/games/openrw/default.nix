{ stdenv, fetchgit, cmake, sfml, mesa, bullet, glm, libmad, x11 }:

stdenv.mkDerivation rec {
  version = "2016-06-29";
  name = "openrw-${version}";
  src = fetchgit {
    url = "https://github.com/rwengine/openrw";
    rev = "46a7254a41d9f6e1eda8d31e742de492abb2540e";
    sha256 = "16ip9779dy59xcj9src2i4zp8jq2h0h5mb4a7d5cpkhd3xlcpabm";
    fetchSubmodules = true;
  };

  buildInputs = [ cmake sfml mesa bullet glm libmad x11 ];

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
