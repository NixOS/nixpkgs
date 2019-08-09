{ fetchFromGitHub, stdenv, cmake, pkgconfig, curl, libsigcxx, SDL2
, SDL2_image, freetype, libvorbis, libpng, assimp, libGLU_combined
, glew
}:

stdenv.mkDerivation rec {
  pname = "pioneer";
  version = "20190203";

  src = fetchFromGitHub{
    owner = "pioneerspacesim";
    repo = "pioneer";
    rev = version;
    sha256 = "1g34wvgyvz793dhm1k64kl82ib0cavkbg0f2p3fp05b457ycljff";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    curl libsigcxx SDL2 SDL2_image freetype libvorbis libpng
    assimp libGLU_combined glew
  ];

  preConfigure = ''
    export PIONEER_DATA_DIR="$out/share/pioneer/data";
  '';

  meta = with stdenv.lib; {
    description = "A space adventure game set in the Milky Way galaxy at the turn of the 31st century";
    homepage = https://pioneerspacesim.net;
    license = with licenses; [
        gpl3 cc-by-sa-30
    ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
