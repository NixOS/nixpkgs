{ stdenv, fetchFromGitHub, cmake, glew, freeimage,  liblockfile
, openal, libtheora, SDL2, lzo, libjpeg, libogg, tbb
, pcre, makeWrapper, fetchpatch }:

let
  version = "784-october-preview";

  src = fetchFromGitHub {
    owner = "OpenXRay";
    repo = "xray-16";
    rev = version;
    sha256 = "0q0h70gbpscdvn45wpxicljj4ji3cd2maijd5b7jhr1695h61q5y";
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

  patches = [
    (fetchpatch {
      url = "https://github.com/OpenXRay/xray-16/commit/4532cba11e98808c92e56e246188863261ef9201.patch";
      sha256 = "1hrm4rkkg946ai95krzpf3isryzbb2vips63gxf481plv4vlcfc9";
    })
  ];

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
    description = "Improved version of the X-Ray Engine, the game engine used in the world-famous S.T.A.L.K.E.R. game series by GSC Game World";
    homepage = src.meta.homepage;
    license = licenses.unfree // {
      url = "https://github.com/OpenXRay/xray-16/blob/xd_dev/License.txt";
    };
    maintainers = [ maintainers.gnidorah ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
