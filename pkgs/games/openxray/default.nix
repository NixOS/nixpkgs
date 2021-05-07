{ lib, stdenv, fetchFromGitHub, cmake, glew, freeimage,  liblockfile
, openal, libtheora, SDL2, lzo, libjpeg, libogg, tbb
, pcre, makeWrapper, fetchpatch }:

let
  version = "822-december-preview";

  src = fetchFromGitHub {
    owner = "OpenXRay";
    repo = "xray-16";
    rev = version;
    fetchSubmodules = true;
    sha256 = "06f3zjnib7hipyl3hnc6mwcj9f50kbwn522wzdjydz8qgdg60h3m";
  };

  # https://github.com/OpenXRay/xray-16/issues/518
  cryptopp = stdenv.mkDerivation {
    pname = "cryptopp";
    version = "5.6.5";

    inherit src;

    sourceRoot = "source/Externals/cryptopp";

    makeFlags = [ "PREFIX=${placeholder "out"}" ];
    enableParallelBuilding = true;

    doCheck = true;

    meta = with lib; {
      description = "Crypto++, a free C++ class library of cryptographic schemes";
      homepage = "https://cryptopp.com/";
      license = with licenses; [ boost publicDomain ];
      platforms = platforms.all;
    };
  };
in stdenv.mkDerivation rec {
  pname = "openxray";
  inherit version src;

  # TODO https://github.com/OpenXRay/GameSpy/pull/6, check if merged in version > 822
  # Fixes format hardening
  patches = [
    (fetchpatch {
      url = "https://github.com/OpenXRay/GameSpy/pull/6/commits/155af876281f5d94f0142886693314d97deb2d4c.patch";
      sha256 = "1l0vcgvzzx8n56shpblpfdhvpr6c12fcqf35r0mflaiql8q7wn88";
      stripLen = 1;
      extraPrefix = "Externals/GameSpy/";
    })
  ];

  cmakeFlags = [ "-DCMAKE_INCLUDE_PATH=${cryptopp}/include/cryptopp" ];

  buildInputs = [
    glew freeimage liblockfile openal cryptopp libtheora SDL2 lzo
    libjpeg libogg tbb pcre
  ];

  nativeBuildInputs = [ cmake makeWrapper ];

  # https://github.com/OpenXRay/xray-16/issues/786
  preConfigure = ''
    substituteInPlace src/xrCore/xrCore.cpp \
      --replace /usr/share $out/share
  '';

  postInstall = ''
    # needed because of SDL_LoadObject library loading code
    wrapProgram $out/bin/xr_3da \
      --prefix LD_LIBRARY_PATH : $out/lib
  '';

  meta = with lib; {
    description = "Improved version of the X-Ray Engine, the game engine used in the world-famous S.T.A.L.K.E.R. game series by GSC Game World";
    homepage = src.meta.homepage;
    license = licenses.unfree // {
      url = "https://github.com/OpenXRay/xray-16/blob/xd_dev/License.txt";
    };
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
