{ fetchFromGitHub, stdenv, cmake, pkgconfig, curl, libsigcxx, SDL2
, SDL2_image, freetype, libvorbis, libpng, assimp, libGLU, libGL
, glew
}:

stdenv.mkDerivation rec {
  pname = "pioneer";
  version = "20200203";

  src = fetchFromGitHub{
    owner = "pioneerspacesim";
    repo = "pioneer";
    rev = version;
    sha256 = "1011xsi94jhw98mhm8kryq8ajig0qfbrdx5xdasi92bd4nk7lcp8";
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
