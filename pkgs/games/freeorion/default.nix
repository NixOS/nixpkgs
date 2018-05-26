{ stdenv, fetchFromGitHub, fetchpatch, cmake, doxygen, graphviz, makeWrapper
, boost, SDL2, python2, freetype, openal, libogg, libvorbis, zlib, libpng, libtiff
, libjpeg, libGLU_combined, glew, libxslt
}:

stdenv.mkDerivation rec {
  version = "0.4.7.1";
  name = "freeorion-${version}";

  src = fetchFromGitHub {
    owner  = "freeorion";
    repo   = "freeorion";
    rev    = "v${version}";
    sha256 = "1m05l3a6ilqd7p2g3aqjpq89grb571cg8n9bpgz0y3sxskcym6sp";
  };

  buildInputs = [ boost SDL2 python2 freetype openal libogg libvorbis zlib libpng libtiff libjpeg libGLU_combined glew ];

  nativeBuildInputs = [ cmake doxygen graphviz makeWrapper ];

  enableParallelBuilding = true;

  patches = [
    # fix build with boost 1.66
    (fetchpatch {
      url = https://github.com/freeorion/freeorion/commit/c9b5b13fb81b1ed142dee0e843101c6b8832ca95.patch;
      sha256 = "0agqhxk8462sgd230lmdzbrbrfd77zyy7a4g8hrf28zxza1nza94";
    })
    ./fix_rpaths.patch
  ];

  postInstall = ''
    mkdir -p $out/fixpaths
    # We need final slashes for XSLT replace to work properly
    substitute ${./fix-paths.xslt} $out/fixpaths/fix-paths.xslt \
      --subst-var-by nixStore "$NIX_STORE/" \
      --subst-var-by out "$out/"
    substitute ${./fix-paths.sh} $out/fixpaths/fix-paths \
      --subst-var-by libxsltBin ${libxslt.bin} \
      --subst-var out
    chmod +x $out/fixpaths/fix-paths

    wrapProgram $out/bin/freeorion \
      --run $out/fixpaths/fix-paths
  '';

  meta = with stdenv.lib; {
    description = "A free, open source, turn-based space empire and galactic conquest (4X) computer game";
    homepage = http://www.freeorion.org;
    license = with licenses; [ gpl2 cc-by-sa-30 ];
    platforms = platforms.linux;
  };
}
