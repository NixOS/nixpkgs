{stdenv, fetchurl, SDL, ftgl, pkgconfig, libpng, libjpeg, pcre, SDL_image, glew, mesa}:
 
stdenv.mkDerivation {
  name = "gource-0.37";
  
  src = fetchurl {
    url = http://gource.googlecode.com/files/gource-0.37.tar.gz;
    sha256 = "03kd9nn65cl1p2jgn6pvpxmvnfscz3c8jqds90fsc0z37ij2iiyn";
  };
  
  buildInputs = [glew SDL ftgl pkgconfig libpng libjpeg pcre SDL_image mesa];

}
