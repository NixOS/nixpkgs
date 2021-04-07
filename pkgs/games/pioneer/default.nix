{ fetchFromGitHub, lib, stdenv, cmake, pkg-config, curl, libsigcxx, SDL2
, SDL2_image, freetype, libvorbis, libpng, assimp, libGLU, libGL
, glew
}:

stdenv.mkDerivation rec {
  pname = "pioneer";
  version = "20210203";

  src = fetchFromGitHub{
    owner = "pioneerspacesim";
    repo = "pioneer";
    rev = version;
    sha256 = "sha256-51HXbX15uB1Xf9Re7Qi41BnJ9OW+GeXQhylJ+HwP0f8=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    curl libsigcxx SDL2 SDL2_image freetype libvorbis libpng
    assimp libGLU libGL glew
  ];

  preConfigure = ''
    export PIONEER_DATA_DIR="$out/share/pioneer/data";
  '';

  meta = with lib; {
    description = "A space adventure game set in the Milky Way galaxy at the turn of the 31st century";
    homepage = "https://pioneerspacesim.net";
    license = with licenses; [
        gpl3 cc-by-sa-30
    ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
