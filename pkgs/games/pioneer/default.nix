{ fetchFromGitHub, stdenv, automake, curl, libsigcxx, SDL2
, SDL2_image, freetype, libvorbis, libpng, assimp, mesa
, autoconf, pkgconfig }:

let
  version = "20160116";
  checksum = "07w5yin2xhb0fdlj1aipi64yx6vnr1siahsy0bxvzi06d73ffj6r";
in
stdenv.mkDerivation rec {
  name = "pioneer-${version}";

  src = fetchFromGitHub{
    owner = "pioneerspacesim";
    repo = "pioneer";
    rev = version;
    sha256 = checksum;
  };

  buildInputs = [
    automake curl libsigcxx SDL2 SDL2_image freetype libvorbis
    libpng assimp mesa autoconf pkgconfig
  ];

  NIX_CFLAGS_COMPILE = [
    "-I${SDL2}/include/SDL2"
  ];


  preConfigure = ''
     export PIONEER_DATA_DIR="$out/share/pioneer/data";
    ./bootstrap
  '';

  meta = with stdenv.lib; {
    description = "Pioneer is a space adventure game set in the Milky Way galaxy at the turn of the 31st century";
    homepage = http://pioneerspacesim.net;
    license = with licenses; [
        gpl3 cc-by-sa-30
    ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
