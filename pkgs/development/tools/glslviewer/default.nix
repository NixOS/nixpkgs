{ stdenv, fetchFromGitHub, glfw, pkgconfig, libXrandr, libXdamage
, libXext, libXrender, libXinerama, libXcursor, libXxf86vm, libXi
, libX11, libGLU, python2Packages, ensureNewerSourcesForZipFilesHook
, Cocoa
}:

stdenv.mkDerivation rec {
  name = "glslviewer-${version}";
  version = "2018-01-31";

  src = fetchFromGitHub {
    owner = "patriciogonzalezvivo";
    repo = "glslViewer";
    rev = "cac40f6984dbeb638950744c9508aa88591fea6c";
    sha256 = "1bykpp68hdxjlxvi1xicyb6822mz69q0adz24faaac372pls4bk0";
  };

  nativeBuildInputs = [ pkgconfig ensureNewerSourcesForZipFilesHook ];
  buildInputs = [
    glfw libGLU glfw libXrandr libXdamage
    libXext libXrender libXinerama libXcursor libXxf86vm
    libXi libX11
  ] ++ (with python2Packages; [ python setuptools wrapPython ])
    ++ stdenv.lib.optional stdenv.isDarwin Cocoa;
  pythonPath = with python2Packages; [ requests ];

  # Makefile has /usr/local/bin hard-coded for 'make install'
  preConfigure = ''
    substituteInPlace Makefile \
        --replace '/usr/local' "$out" \
        --replace '/usr/bin/clang++' 'clang++'
    substituteInPlace Makefile \
        --replace 'python setup.py install' "python setup.py install --prefix=$out"
  '';

  preInstall = ''
    mkdir -p $out/bin $(toPythonPath "$out")
    export PYTHONPATH=$PYTHONPATH:$(toPythonPath "$out")
  '';

  postInstall = ''
    wrapPythonPrograms
  '';

  meta = with stdenv.lib; {
    description = "Live GLSL coding renderer";
    homepage = http://patriciogonzalezvivo.com/2015/glslViewer/;
    license = licenses.bsd3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.hodapp ];
  };
}
