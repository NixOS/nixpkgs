{ lib, stdenv, fetchurl
, libpng, libjpeg, libogg, libvorbis, freetype, smpeg
, SDL, SDL_image, SDL_mixer, SDL_ttf }:


stdenv.mkDerivation {
  name = "onscripter-en-20110930";

  src = fetchurl {
    # The website is not available now.
    url = "https://www.dropbox.com/s/ag21owy9poyr2oy/onscripter-en-20110930-src.tar.bz2";
    sha256 = "1kzm6d894c0ihgkwhd03x3kaqqz0sb6kf0r86xrrz12y309zfam6";
  };

  buildInputs = [ libpng libjpeg libogg libvorbis freetype smpeg
                  SDL SDL_image SDL_mixer SDL_ttf
                ];

  configureFlags = [ "--no-werror" ];

  # Without this libvorbisfile.so is not getting linked properly for some reason.
  NIX_CFLAGS_LINK = "-lvorbisfile";

  preBuild = ''
    sed -i 's/.dll//g' Makefile
  '';

  meta = with lib; {
    description = "Japanese visual novel scripting engine";
    homepage = "http://unclemion.com/onscripter/";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
