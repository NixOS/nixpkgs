{ stdenv, fetchFromGitHub, cmake, boost165, pkgconfig, guile,
eigen, libpng, python, libGLU, qt4, openexr, openimageio,
opencolorio, xercesc, ilmbase, osl, seexpr, makeWrapper
}:

let boost_static = boost165.override {
  enableStatic = true;
  enablePython = true;
};
in stdenv.mkDerivation rec {

  pname = "appleseed";
  version = "2.0.5-beta";

  src = fetchFromGitHub {
    owner  = "appleseedhq";
    repo   = "appleseed";
    rev    = version;
    sha256 = "1sq9s0rzjksdn8ayp1g17gdqhp7fqks8v1ddd3i5rsl96b04fqx5";
  };
  buildInputs = [
    cmake pkgconfig boost_static guile eigen libpng python
    libGLU qt4 openexr openimageio opencolorio xercesc
    osl seexpr makeWrapper
  ];

  NIX_CFLAGS_COMPILE = toString [
    "-I${openexr.dev}/include/OpenEXR"
    "-I${ilmbase.dev}/include/OpenEXR"
    "-I${openimageio.dev}/include/OpenImageIO"

    "-Wno-unused-but-set-variable"
    "-Wno-error=class-memaccess"
    "-Wno-error=maybe-uninitialized"
    "-Wno-error=catch-value"
    "-Wno-error=stringop-truncation"
  ];

  cmakeFlags = [
      "-DUSE_EXTERNAL_XERCES=ON" "-DUSE_EXTERNAL_OCIO=ON" "-DUSE_EXTERNAL_OIIO=ON"
      "-DUSE_EXTERNAL_OSL=ON" "-DWITH_CLI=ON" "-DWITH_STUDIO=ON" "-DWITH_TOOLS=ON"
      "-DUSE_EXTERNAL_PNG=ON" "-DUSE_EXTERNAL_ZLIB=ON"
      "-DUSE_EXTERNAL_EXR=ON" "-DUSE_EXTERNAL_SEEXPR=ON"
      "-DWITH_PYTHON=ON"
      "-DWITH_DISNEY_MATERIAL=ON"
      "-DUSE_SSE=ON"
      "-DUSE_SSE42=ON"
  ];
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Open source, physically-based global illumination rendering engine";
    homepage = https://appleseedhq.net/;
    maintainers = with maintainers; [ hodapp ];
    license = licenses.mit;
    platforms = platforms.linux;
  };

  # Work around a bug in the CMake build:
  postInstall = ''
    chmod a+x $out/bin/*
    wrapProgram $out/bin/appleseed.studio --set PYTHONHOME ${python}
  '';
}

# TODO: Is the below problematic?

# CMake Warning (dev) at /nix/store/dsyw2zla2h3ld2p0jj4cv0j3wal1bp3h-cmake-3.11.2/share/cmake-3.11/Modules/FindOpenGL.cmake:270 (message):
#  Policy CMP0072 is not set: FindOpenGL prefers GLVND by default when
#  available.  Run "cmake --help-policy CMP0072" for policy details.  Use the
#  cmake_policy command to set the policy and suppress this warning.
#
#  FindOpenGL found both a legacy GL library:
#
#    OPENGL_gl_LIBRARY: /nix/store/yxrgmcz2xlgn113wz978a91qbsy4rc8g-libGL-1.0.0/lib/libGL.so
#
#  and GLVND libraries for OpenGL and GLX:
#
#    OPENGL_opengl_LIBRARY: /nix/store/yxrgmcz2xlgn113wz978a91qbsy4rc8g-libGL-1.0.0/lib/libOpenGL.so
#    OPENGL_glx_LIBRARY: /nix/store/yxrgmcz2xlgn113wz978a91qbsy4rc8g-libGL-1.0.0/lib/libGLX.so
#
#  OpenGL_GL_PREFERENCE has not been set to "GLVND" or "LEGACY", so for
#  compatibility with CMake 3.10 and below the legacy GL library will be used.
