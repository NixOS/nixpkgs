{ lib
, stdenv
, fetchFromGitHub
, cmake
, doxygen
, graphviz
, makeWrapper
, cppcheck
, boost16x
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
  version = "0.4.10.1";
  pname = "freeorion";

  src = fetchFromGitHub {
    owner = "freeorion";
    repo = "freeorion";
    rev = "v${version}";
    sha256 = "sha256-Itt2JIStx+JsnMMBvbeJXSEJpaS/pd1UMvPGNd50k7I=";
  };

  buildInputs = [
    (boost16x.override { enablePython = true; python = python3; })
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
    cppcheck
    doxygen
    graphviz
    makeWrapper
  ];

  # as of 0.4.10.1 FreeOrion doesn't work with "-DOpenGL_GL_PREFERENCE=GLVND"
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
    homepage = "http://www.freeorion.org";
    license = with licenses; [ gpl2 cc-by-sa-30 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ tex ];
  };
}
