{ stdenv, fetchurl, qt4 }:

stdenv.mkDerivation rec {
  name = "nifskope-1.1.3";

  src = fetchurl {
    url = "mirror://sourceforge/niftools/${name}.tar.bz2";
    sha256 = "0fcvrcjyvivww10sjhxamcip797b9ykbf5p3rm2k24xhkwdaqp72";
  };

  buildInputs = [ qt4 ];

  configurePhase =
    ''
      for i in *.cpp gl/*.cpp widgets/*.cpp; do
        substituteInPlace $i --replace /usr/share/nifskope $out/share/nifskope
      done

      qmake -after TARGET=nifskope
    ''; # */

  enableParallelBuilding = true;

  # Inspired by linux-install/nifskope.spec.in.
  installPhase =
    ''
      d=$out/share/nifskope
      mkdir -p $out/bin $out/share/applications $out/share/pixmaps $d/{shaders,doc,lang}
      cp release/nifskope $out/bin/
      cp nifskope.png $out/share/pixmaps/
      cp nif.xml kfm.xml style.qss $d/
      cp shaders/*.frag shaders/*.prog shaders/*.vert $d/shaders/
      cp doc/*.html doc/docsys.css doc/favicon.ico $d/doc/
      cp lang/*.ts lang/*.tm $d/lang/

      substituteInPlace nifskope.desktop \
        --replace 'Exec=nifskope' "Exec=$out/bin/nifskope" \
        --replace 'Icon=nifskope' "Icon=$out/share/pixmaps/nifskope.png"
      cp nifskope.desktop $out/share/applications/

      find $out/share -type f -exec chmod -x {} \;
    ''; # */

  meta = {
    homepage = http://niftools.sourceforge.net/;
    description = "A tool for analyzing and editing NetImmerse/Gamebryo '*.nif' files";
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.bsd3;
  };
}
