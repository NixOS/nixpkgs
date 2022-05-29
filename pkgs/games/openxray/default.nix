{ lib
, stdenv
, fetchFromGitHub
, cmake
, glew
, freeimage
, liblockfile
, openal
, libtheora
, SDL2
, lzo
, libjpeg
, libogg
, pcre
, makeWrapper
, enableMultiplayer ? false # Requires old, insecure Crypto++ version
}:

let
  version = "1144-december-2021-rc1";

  src = fetchFromGitHub {
    owner = "OpenXRay";
    repo = "xray-16";
    rev = version;
    fetchSubmodules = true;
    sha256 = "07qj1lpp21g4p583gvz5h66y2q71ymbsz4g5nr6dcys0vm7ph88v";
  };

  # https://github.com/OpenXRay/xray-16/issues/518
  ancientCryptopp = stdenv.mkDerivation {
    pname = "cryptopp";
    version = "5.6.5";

    inherit src;

    sourceRoot = "source/Externals/cryptopp";

    installFlags = [ "PREFIX=${placeholder "out"}" ];

    enableParallelBuilding = true;

    doCheck = true;

    dontStrip = true;

    meta = with lib; {
      description = "Crypto++, a free C++ class library of cryptographic schemes";
      homepage = "https://cryptopp.com/";
      license = with licenses; [ boost publicDomain ];
      platforms = platforms.all;
      knownVulnerabilities = [
        "CVE-2019-14318"
      ];
    };
  };
in
stdenv.mkDerivation rec {
  pname = "openxray";

  inherit version src;

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  buildInputs = [
    glew
    freeimage
    liblockfile
    openal
    libtheora
    SDL2
    lzo
    libjpeg
    libogg
    pcre
  ] ++ lib.optionals enableMultiplayer [
    ancientCryptopp
  ];

  # Crashes can happen, we'd like them to be reasonably debuggable
  cmakeBuildType = "RelWithDebInfo";
  dontStrip = true;

  cmakeFlags = [
    "-DUSE_CRYPTOPP=${if enableMultiplayer then "ON" else "OFF"}"
  ] ++ lib.optionals enableMultiplayer [
    "-DCMAKE_INCLUDE_PATH=${ancientCryptopp}/include/cryptopp"
  ];

  postInstall = ''
    # needed because of SDL_LoadObject library loading code
    wrapProgram $out/bin/xr_3da \
      --prefix LD_LIBRARY_PATH : $out/lib
  '';

  meta = with lib; {
    mainProgram = "xray-16";
    description = "Improved version of the X-Ray Engine, the game engine used in the world-famous S.T.A.L.K.E.R. game series by GSC Game World";
    homepage = "https://github.com/OpenXRay/xray-16/";
    license = licenses.unfree // {
      url = "https://github.com/OpenXRay/xray-16/blob/xd_dev/License.txt";
    };
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
