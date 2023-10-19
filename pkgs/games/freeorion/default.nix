{ lib
, stdenv
, fetchFromGitHub
, cmake
, doxygen
, graphviz
, makeWrapper
, boost179
, SDL2
, python3
, freetype
, openal
, libogg
, libvorbis
, zlib
, libpng
, libtiff
, libjpeg
, libGLU
, libGL
, glew
, libxslt
}:

stdenv.mkDerivation rec {
  pname = "freeorion";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "freeorion";
    repo = "freeorion";
    rev = "v${version}";
    sha256 = "sha256-uJRDU0Xd+sHL2IDvMiElUSOhvchVMW9wYMSLSN7pYtQ=";
  };

  buildInputs = [
    (boost179.override { enablePython = true; python = python3; })
    (python3.withPackages (p: with p; [ pycodestyle ]))
    SDL2
    freetype
    glew
    libGL
    libGLU
    libjpeg
    libogg
    libpng
    libtiff
    libvorbis
    openal
    zlib
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    makeWrapper
  ];

  # as of 0.5 FreeOrion doesn't work with "-DOpenGL_GL_PREFERENCE=GLVND"
  cmakeFlags = [ "-DOpenGL_GL_PREFERENCE=LEGACY" ];

  postInstall = ''
    mkdir -p $out/libexec
    # We need final slashes for XSLT replace to work properly
    substitute ${./fix-paths.xslt} $out/share/freeorion/fix-paths.xslt \
      --subst-var-by nixStore "$NIX_STORE/" \
      --subst-var-by out "$out/"
    substitute ${./fix-paths.sh} $out/libexec/fix-paths \
      --subst-var-by libxsltBin ${libxslt.bin} \
      --subst-var-by shell ${stdenv.shell} \
      --subst-var out
    chmod +x $out/libexec/fix-paths

    wrapProgram $out/bin/freeorion \
      --run $out/libexec/fix-paths \
      --prefix LD_LIBRARY_PATH : $out/lib/freeorion
  '';

  meta = with lib; {
    description = "A free, open source, turn-based space empire and galactic conquest (4X) computer game";
    homepage = "https://www.freeorion.org/";
    license = with licenses; [ gpl2 cc-by-sa-30 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ tex ];
  };
}
