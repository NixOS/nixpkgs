buildinputs="$wxGTK $python $pkgconfig $gtk"
. $stdenv/setup

tar xvfz $src
cd wxPythonSrc-*/wxPython
python setup.py WXPORT=gtk2 BUILD_GLCANVAS=0 BUILD_OGL=0 build install --prefix=$out
