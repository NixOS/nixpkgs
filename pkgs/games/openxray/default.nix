{ stdenv, fetchFromGitHub, cmake, glew, freeimage,  liblockfile
, openal, libtheora, SDL2, lzo, libjpeg, libogg, tbb
, pcre, makeWrapper }:

let
  version = "730-july-preview";

  src = fetchFromGitHub {
    owner = "OpenXRay";
    repo = "xray-16";
    rev = version;
    sha256 = "1nish3sbpk0hsag7r4nyx8j6pl9mlgx58v8dhzg2vwj2q32isyb2";
    fetchSubmodules = true;
  };

  # https://github.com/OpenXRay/xray-16/issues/518
  cryptopp = stdenv.mkDerivation {
    pname = "cryptopp";
    version = "5.6.5";

    inherit src;

    postUnpack = "sourceRoot+=/Externals/cryptopp";

    makeFlags = [ "PREFIX=${placeholder "out"}" ];
    enableParallelBuilding = true;

    doCheck = true;

    meta = with stdenv.lib; {
      description = "Crypto++, a free C++ class library of cryptographic schemes";
      homepage = "https://cryptopp.com/";
      license = with licenses; [ boost publicDomain ];
      platforms = platforms.all;
    };
  };
in stdenv.mkDerivation rec {
  pname = "OpenXRay";
  inherit version src;

  hardeningDisable = [ "format" ];
  cmakeFlags = [ "-DCMAKE_INCLUDE_PATH=${cryptopp}/include/cryptopp" ];

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
    # needed because of SDL_LoadObject library loading code
    wrapProgram $out/bin/xr_3da \
      --prefix LD_LIBRARY_PATH : $out/lib
  '';

  meta = with stdenv.lib; {
    description = "X-Ray Engine 1.6 expansion. Original version was used in S.T.A.L.K.E.R.: Call of Pripyat";
    homepage = src.meta.homepage;
    license = licenses.unfree // {
      url = "https://github.com/OpenXRay/xray-16/blob/xd_dev/License.txt";
    };
    maintainers = [ maintainers.gnidorah ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
