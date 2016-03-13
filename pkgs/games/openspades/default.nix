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

  # https://github.com/yvt/openspades/issues/354
  postPatch = ''
    substituteInPlace Sources/Client/Client_Input.cpp --replace "isnan(" "std::isnan("
    substituteInPlace Sources/Client/Corpse.cpp --replace "isnan(" "std::isnan("
    substituteInPlace Sources/Draw/SWMapRenderer.cpp --replace "isnan(" "std::isnan(" --replace "isinf(" "std::isinf("
  '';

  nativeBuildInputs = 
    with stdenv.lib;
    [ cmake curl glew makeWrapper mesa SDL2 SDL2_image unzip wget zlib ]
    ++ optional withOpenal openal;

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" "-DOPENSPADES_INSTALL_BINARY=bin" ];

  enableParallelBuilding = true;

  devPack = fetchurl {
    url = "http://yvt.jp/files/programs/osppaks/DevPaks27.zip";
    sha256 = "05y7wldg70v5ys41fm0c8kipyspn524z4pglwr3p8h0gfz9n52v6";
  };

  preBuild = ''
    cp $devPack Resources/DevPaks27.zip
    unzip -u -o Resources/DevPaks27.zip -d Resources/DevPak
  '';

  # OpenAL is loaded dynamicly
  postInstall = 
    if withOpenal then ''
      wrapProgram "$out/bin/openspades" \
        --prefix LD_LIBRARY_PATH : "${openal}/lib"
    '' 
    else null;

  meta = with stdenv.lib; {
    description = "A compatible client of Ace of Spades 0.75";
    homepage    = "https://github.com/yvt/openspades/";
    license     = licenses.gpl3;
    platforms   = platforms.linux;
  };
}
