{ fetchFromGitHub, stdenv, autoconf, automake, pkgconfig
, curl, libsigcxx, SDL2, SDL2_image, freetype, libvorbis, libpng, assimp, mesa
}:

stdenv.mkDerivation rec {
  name = "pioneer-${version}";
  version = "20171001";

  src = fetchFromGitHub{
    owner = "pioneerspacesim";
    repo = "pioneer";
    rev = version;
    sha256 = "0yxw1zdvidrwc28vxfi3qpx2nq2dix2d6ylwgzq9ph8kgwv9fl5n";
  };

  nativeBuildInputs = [ autoconf automake pkgconfig ];

  buildInputs = [ curl libsigcxx SDL2 SDL2_image freetype libvorbis libpng assimp mesa ];

  NIX_CFLAGS_COMPILE = [
    "-I${SDL2}/include/SDL2"
  ];

  preConfigure = ''
     export PIONEER_DATA_DIR="$out/share/pioneer/data";
    ./bootstrap
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A space adventure game set in the Milky Way galaxy at the turn of the 31st century";
    homepage = https://pioneerspacesim.net;
    license = with licenses; [
        gpl3 cc-by-sa-30
    ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
