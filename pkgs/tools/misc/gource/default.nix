{stdenv, fetchurl, SDL, ftgl, pkgconfig, libpng, libjpeg, pcre, SDL_image, glew, mesa}:
 
stdenv.mkDerivation {
  name = "gource-0.28";
  
  src = fetchurl {
    url = http://gource.googlecode.com/files/gource-0.28.tar.gz;
    sha256 = "09538vcf9n21qx4cmcjrki6ilayvm4x6s0zdf00mrd1h0bklhxn3";
  };
  
  buildInputs = [glew SDL ftgl pkgconfig libpng libjpeg pcre SDL_image mesa];

}
