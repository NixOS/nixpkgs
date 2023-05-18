{ lib, stdenv, fetchurl, cmake, pkg-config
, SDL2, libvorbis, libogg, libjpeg, libpng, freetype, glew, tinyxml, openal
, freealut, readline, gcc-unwrapped
, enableSoundtrack ? false # Enable the "Open Clonk Soundtrack - Explorers Journey" by David Oerther
}:

let
  soundtrack_src = fetchurl {
    url = "http://www.openclonk.org/download/Music.ocg";
    sha256 = "1ckj0dlpp5zsnkbb5qxxfxpkiq76jj2fgj91fyf3ll7n0gbwcgw5";
  };
in stdenv.mkDerivation rec {
  version = "8.1";
  pname = "openclonk";

  src = fetchurl {
    url = "https://www.openclonk.org/builds/release/8.1/openclonk-${version}-src.tar.bz2";
    sha256 = "0imkqjp8lww5p0cnqf4k4mb2v682mnsas63qmiz17rspakr7fxik";
  };

  postInstall = ''
    mv -v $out/games/openclonk $out/bin/
  '' + lib.optionalString enableSoundtrack ''
    ln -sv ${soundtrack_src} $out/share/games/openclonk/Music.ocg
  '';

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    SDL2 libvorbis libogg libjpeg libpng freetype glew tinyxml openal freealut
    readline
  ];

  cmakeFlags = [ "-DCMAKE_AR=${gcc-unwrapped}/bin/gcc-ar" "-DCMAKE_RANLIB=${gcc-unwrapped}/bin/gcc-ranlib" ];

  cmakeBuildType = "RelWithDebInfo";

  meta = with lib; {
    description = "Free multiplayer action game in which you control clonks, small but witty and nimble humanoid beings";
    homepage = "https://www.openclonk.org";
    license = if enableSoundtrack then licenses.unfreeRedistributable else licenses.isc;
    maintainers = with maintainers; [ lheckemann ];
    platforms = [ "x86_64-linux" "i686-linux" ];
    broken = true;
  };
}
