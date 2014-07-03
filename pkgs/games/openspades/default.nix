{ stdenv, fetchurl, cmake, curl, glew, makeWrapper, mesa, SDL2,
  SDL2_image, unzip, wget, zlib, withOpenal ? true, openal ? null }:

assert withOpenal -> openal != null;

stdenv.mkDerivation rec {
  name = "openspades-${version}";
  version = "0.0.12";

  src = fetchurl {
    url = "https://github.com/yvt/openspades/archive/v${version}.tar.gz";
    sha256 = "1aa848cck8qrp67ha9vrkzm3k24r2aiv1v4dxla6pi22rw98yxzm";
  };

  nativeBuildInputs = 
    with stdenv.lib;
    [ cmake curl glew makeWrapper mesa SDL2 SDL2_image unzip wget zlib ]
    ++ optional withOpenal openal;

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" "-DOPENSPADES_INSTALL_BINARY=bin" ];

  # OpenAL is loaded dynamicly
  postInstall = 
    if withOpenal then ''
      wrapProgram "$out/bin/openspades" \
        --prefix LD_LIBRARY_PATH : "${openal}/lib"
    '' 
    else null;

  meta = with stdenv.lib; {
    description = "OpenSpades is a compatible client of Ace of Spades 0.75";
    homepage    = "https://github.com/yvt/openspades/";
    license     = licenses.gpl3;
    platforms   = platforms.linux;
  };
}
