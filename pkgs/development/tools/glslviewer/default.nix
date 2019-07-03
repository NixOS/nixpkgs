{ stdenv, fetchFromGitHub, glfw, pkgconfig, libXrandr, libXdamage
, libXext, libXrender, libXinerama, libXcursor, libXxf86vm, libXi
, libX11, libGLU, python2Packages, ensureNewerSourcesForZipFilesHook
, Cocoa
}:

stdenv.mkDerivation rec {
  name = "glslviewer-${version}";
  version = "2019-04-22";

  src = fetchFromGitHub {
    owner = "patriciogonzalezvivo";
    repo = "glslViewer";
    rev = "fa3e2ed4810927d189e480b704366cca22f281f3";
    sha256 = "1888jxi84f2nnc0kpzqrn2cada1z4zqyq8ss4ppb5y3wy7d87qjn";
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
