{ stdenv, fetchFromGitHub, glfw, pkgconfig, libXrandr, libXdamage
, libXext, libXrender, libXinerama, libXcursor, libXxf86vm, libXi
, libX11, libGLU, python3Packages, ensureNewerSourcesForZipFilesHook
, Cocoa
}:

stdenv.mkDerivation rec {
  pname = "glslviewer";
  version = "1.6.8";

  src = fetchFromGitHub {
    owner = "patriciogonzalezvivo";
    repo = "glslViewer";
    rev = version;
    sha256 = "0v7x93b61ama0gmzlx1zc56jgi7bvzsfvbkfl82xzwf2h5g1zni7";
  };

  nativeBuildInputs = [ pkgconfig ensureNewerSourcesForZipFilesHook python3Packages.six ];
  buildInputs = [
    glfw libGLU glfw libXrandr libXdamage
    libXext libXrender libXinerama libXcursor libXxf86vm
    libXi libX11
  ] ++ (with python3Packages; [ python setuptools wrapPython ])
    ++ stdenv.lib.optional stdenv.isDarwin Cocoa;
  pythonPath = with python3Packages; [ pyyaml requests ];

  # Makefile has /usr/local/bin hard-coded for 'make install'
  preConfigure = ''
    substituteInPlace Makefile \
        --replace '/usr/local' "$out" \
        --replace '/usr/bin/clang++' 'clang++'
    substituteInPlace Makefile \
        --replace 'python setup.py install' "python setup.py install --prefix=$out"
    2to3 -w bin/*
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
    homepage = "http://patriciogonzalezvivo.com/2015/glslViewer/";
    license = licenses.bsd3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.hodapp ];
  };
}
