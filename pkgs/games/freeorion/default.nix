{ stdenv, fetchFromGitHub, fetchpatch, cmake, doxygen, graphviz, makeWrapper
, boost, SDL2, python2, freetype, openal, libogg, libvorbis, zlib, libpng, libtiff
, libjpeg, libGLU_combined, glew, libxslt
}:

stdenv.mkDerivation rec {
  version = "0.4.8";
  name = "freeorion-${version}";

  src = fetchFromGitHub {
    owner  = "freeorion";
    repo   = "freeorion";
    rev = "v${version}";
    sha256 = "1lj1q2ljjgbbiqxb53wdrrcz0zxxr3vv9jqrhbzvfsss7q808jfw";
  };

  buildInputs = [
	(boost.override { enablePython = true; })
    SDL2 python2 freetype openal libogg libvorbis zlib libpng libtiff libjpeg libGLU_combined glew ];

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
