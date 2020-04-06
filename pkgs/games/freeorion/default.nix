{ stdenv, fetchFromGitHub, cmake, doxygen, graphviz, makeWrapper
, boost168, SDL2, python2, freetype, openal, libogg, libvorbis, zlib, libpng, libtiff
, libjpeg, libGLU, libGL, glew, libxslt
}:

stdenv.mkDerivation rec {
  version = "0.4.9";
  pname = "freeorion";

  src = fetchFromGitHub {
    owner  = "freeorion";
    repo   = "freeorion";
    rev = "v${version}";
    sha256 = "18xigx4qla225ybf7mc1w8zfm81nhcm1i5181n5l2fbndvslb1wf";
  };

  buildInputs = [
	(boost168.override { enablePython = true; })
    SDL2 python2 freetype openal libogg libvorbis zlib libpng libtiff libjpeg libGLU libGL glew ];

  nativeBuildInputs = [ cmake doxygen graphviz makeWrapper ];

  enableParallelBuilding = true;

  patches = [
  ];

  postInstall = ''
    mkdir -p $out/fixpaths
    # We need final slashes for XSLT replace to work properly
    substitute ${./fix-paths.xslt} $out/fixpaths/fix-paths.xslt \
      --subst-var-by nixStore "$NIX_STORE/" \
      --subst-var-by out "$out/"
    substitute ${./fix-paths.sh} $out/fixpaths/fix-paths \
      --subst-var-by libxsltBin ${libxslt.bin} \
      --subst-var-by shell ${stdenv.shell} \
      --subst-var out
    chmod +x $out/fixpaths/fix-paths

    wrapProgram $out/bin/freeorion \
      --run $out/fixpaths/fix-paths \
      --prefix LD_LIBRARY_PATH : $out/lib/freeorion
  '';

  meta = with stdenv.lib; {
    description = "A free, open source, turn-based space empire and galactic conquest (4X) computer game";
    homepage = http://www.freeorion.org;
    license = with licenses; [ gpl2 cc-by-sa-30 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ tex ];
  };
}
