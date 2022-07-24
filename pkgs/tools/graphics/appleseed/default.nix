{ lib
, stdenv
, fetchFromGitHub
, cmake
, boost
, pkg-config
, guile
, eigen
, libpng
, python2
, libGLU
, qtbase
, openexr
, openimageio2
, opencolorio
, xercesc
, ilmbase
, osl
, lz4
, seexpr
, wrapQtAppsHook
, fetchpatch
}:

let

  boost_static = boost.override {
    enableStatic = true;
    enablePython = true;
    python = python2;
  };

in stdenv.mkDerivation rec {

  pname = "appleseed";
  version = "2.1.0-beta";

  src = fetchFromGitHub {
    owner = "appleseedhq";
    repo = pname;
    rev = version;
    sha256 = "sha256-haPHP6aNelXgP4No385I4FlND1L9TLbFOSYYzvzJYkA=";
  };

  patches = [
    # Fix compilation against OSL 1.11.X
    # https://github.com/appleseedhq/appleseed/issues/2892
    (fetchpatch {
      url = "https://github.com/appleseedhq/appleseed/commit/92b553fb15108177aec9a518712da88afa5ed7ad.patch";
      sha256 = "sha256-vAEbjBSuCryR7S5QrUzZfzK1K/wDuuc9qq8AVjQg7qU=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    boost_static
    eigen
    guile
    libGLU
    libpng
    lz4
    opencolorio
    openexr
    openimageio2
    osl
    python2
    qtbase
    seexpr
    xercesc
  ];

  NIX_CFLAGS_COMPILE = toString [
    "-I${openexr.dev}/include/OpenEXR"
    "-I${ilmbase.dev}/include/OpenEXR"
    "-I${openimageio2.dev}/include/OpenImageIO"

    "-Wno-unused-but-set-variable"
    "-Wno-error=class-memaccess"
    "-Wno-error=maybe-uninitialized"
    "-Wno-error=catch-value"
    "-Wno-error=stringop-truncation"
    "-Wno-error=array-bounds"
  ];

  cmakeFlags = [
    "-DUSE_EXTERNAL_XERCES=ON"
    "-DUSE_EXTERNAL_OCIO=ON"
    "-DUSE_EXTERNAL_OIIO=ON"
    "-DUSE_EXTERNAL_OSL=ON"
    "-DWITH_CLI=ON"
    "-DWITH_STUDIO=ON"
    "-DWITH_TOOLS=ON"
    "-DUSE_EXTERNAL_PNG=ON"
    "-DUSE_EXTERNAL_ZLIB=ON"
    "-DUSE_EXTERNAL_EXR=ON"
    "-DUSE_EXTERNAL_SEEXPR=ON"
    "-DWITH_PYTHON=ON"
    "-DWITH_DISNEY_MATERIAL=ON"
    "-DUSE_SSE=ON"
    "-DUSE_SSE42=ON"
  ];

  # Work around a bug in the CMake build:
  postInstall = ''
    chmod a+x $out/bin/*
    wrapProgram $out/bin/appleseed.studio --set PYTHONHOME ${python2}
  '';

  meta = with lib; {
    description = "Open source, physically-based global illumination rendering engine";
    homepage = "https://appleseedhq.net";
    license = licenses.mit;
    maintainers = with maintainers; [ hodapp ];
    platforms = platforms.linux;
  };
}
