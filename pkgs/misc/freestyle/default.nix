{ stdenv, fetchurl, qt4, libpng, lib3ds, freeglut, libXi, libQGLViewer
, swig, python }:

stdenv.mkDerivation {
  name = "freestyle-2.2.0";

  src = fetchurl {
    url = mirror://sourceforge/freestyle/freestyle.2.2.0-src.tar.bz2;
    sha256 = "1h4880fijmfy0x6dbl9hfri071rpj3lnwfzkxi1qyqhy7zyxy7ga";
 };

  buildInputs = [ qt4 libpng lib3ds freeglut libXi libQGLViewer swig ];
  
  inherit python freeglut libQGLViewer lib3ds; # if you want to use another adopt patch and Config.pri 

  buildPhase = ''
    export PYTHON_VERSION=2.5
    cd src/system && qmake -makefile PREFIX=\$out && cd ..
    cd rendering && qmake -makefile PREFIX=\$out && cd ..
    qmake -makefile PREFIX=\$out && make
    cd swig && make -f Makefile
    cd ../..

    hide=$out/nix-support/hide
    moddir=$out/share/freestyle
    mkdir -p $out/bin $moddir $hide
    cp -r style_modules $moddir
    cp build/lib/*.so* $hide
    cp build/Freestyle $hide
    cp -r build/linux-g++/debug/lib/python $hide/pylib
    cat > $out/bin/Freestyle << EOF
      #!/bin/sh
      echo use export PYTHONPATH to add your py files to the search path
      echo the style modules can be loded from directory $moddir
      echo starting Freestyle know - have fun
      echo -e "\n\n\n\n"
      export PYTHONPATH=$PYTHONPATH:$moddir/style_modules:$hide/pylib
      LD_LIBRARY_PATH=$hide
      $hide/Freestyle
    EOF
    chmod +x $out/bin/Freestyle
  '';

  patches = ./patch;

  installPhase = ":";

  meta = { 
    description = "Non-Photorealistic Line Drawing rendering from 3D scenes";
    homepage = http://freestyle.sourceforge.net;
    license = stdenv.lib.licenses.gpl2;
  };
}
