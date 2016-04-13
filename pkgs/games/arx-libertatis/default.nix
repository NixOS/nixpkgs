{ stdenv, fetchgit, cmake, zlib, boost,
  openal, glm, freetype, mesa, glew, SDL2,
  dejavu_fonts }:

stdenv.mkDerivation rec {
  name = "arx-libertatis-${version}";
  version = "2016-02-02";

  src = fetchgit {
    url = "https://github.com/arx/ArxLibertatis";
    rev = "205c6cda4d5ac10f3af4ea7bb89c2fc88dac7c9a";
    sha256 = "0dy81pk4r94qq720kk6ynkjp2wr3z9hzm9h1x46nkkpn7fj8srrn";
  };

  buildInputs = [
    cmake zlib boost openal glm
    freetype mesa glew SDL2
  ];

  preConfigure = ''
    cmakeFlags="-DDATA_DIR_PREFIXES=$out/share"
  '';

  enableParallelBuilding = true;

  postInstall = ''
    ln -sf \
      ${dejavu_fonts}/share/fonts/truetype/DejaVuSansMono.ttf \
      $out/share/games/arx/misc/dejavusansmono.ttf
  '';
  
  meta = with stdenv.lib; {
    description = ''
      A cross-platform, open source port of Arx Fatalis, a 2002
      first-person role-playing game / dungeon crawler
      developed by Arkane Studios.
    '';
    homepage = "http://arx-libertatis.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ rnhmjoj ];
    platform = platforms.all;
  };

}

