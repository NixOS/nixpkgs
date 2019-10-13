{ stdenv, fetchFromGitHub, cmake, glew, freeimage,  liblockfile
, openal, cryptopp, libtheora, SDL2, lzo, libjpeg, libogg, tbb
, pcre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "OpenXRay";
  version = "510";

  src = fetchFromGitHub {
    owner = "OpenXRay";
    repo = "xray-16";
    rev = version;
    sha256 = "0q142l6xvgnd6ycncqld69izxclynqrs73aq89pfy1r1nzhd60ay";
    fetchSubmodules = true;
  };

  hardeningDisable = [ "format" ];
  cmakeFlags = [ "-DCMAKE_INCLUDE_PATH=${cryptopp}/include/cryptopp" ];
  installFlags = [ "DESTDIR=${placeholder "out"}" ];

  buildInputs = [
    glew freeimage liblockfile openal cryptopp libtheora SDL2 lzo
    libjpeg libogg tbb pcre
  ];
  nativeBuildInputs = [ cmake makeWrapper ];

  preConfigure = ''
    substituteInPlace src/xrCore/xrCore.cpp \
      --replace /usr/share $out/share
  '';

  postInstall = ''
    mv $out/var/empty/* $out
    install -Dm755 $out/games/xr_3da $out/bin/xr_3da
    install -Dm644 $src/License.txt $out/share/licenses/openxray/License.txt
    rm -r $out/var $out/games

    # needed because of SDL_LoadObject library loading code
    wrapProgram $out/bin/xr_3da \
      --prefix LD_LIBRARY_PATH : $out/lib
  '';

  meta = with stdenv.lib; {
    description = "X-Ray Engine 1.6 expansion. Original version was used in S.T.A.L.K.E.R.: Call of Pripyat";
    homepage = src.meta.homepage;
    license = licenses.unfree // {
      url = https://github.com/OpenXRay/xray-16/blob/xd_dev/License.txt;
    };
    maintainers = [ maintainers.gnidorah ];
    platforms = ["x86_64-linux" "i686-linux" ];
  };
}
