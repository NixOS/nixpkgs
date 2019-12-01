{ fetchFromGitHub, stdenv, cmake, pkgconfig, curl, libsigcxx, SDL2
, SDL2_image, freetype, libvorbis, libpng, assimp, libGLU, libGL
, glew
}:

stdenv.mkDerivation rec {
  pname = "pioneer";
  version = "20191117";

  src = fetchFromGitHub{
    owner = "pioneerspacesim";
    repo = "pioneer";
    rev = version;
    sha256 = "0ka5w1sfp56bs3njiwyr6ffy34qvqbzcvmra9cqwyvi7famn8b49";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    curl libsigcxx SDL2 SDL2_image freetype libvorbis libpng
    assimp libGLU libGL glew
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
