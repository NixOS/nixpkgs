{ stdenv, fetchFromGitHub, python2Packages }:

stdenv.mkDerivation rec {
  name = "facedetect-${version}";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "wavexx";
    repo = "facedetect";
    rev = "v${version}";
    sha256 = "0mddh71cjbsngpvjli406ndi2x613y39ydgb8bi4z1jp063865sd";
  };

  buildInputs = [ python2Packages.python python2Packages.wrapPython ];
  pythonPath = [ python2Packages.numpy python2Packages.opencv ];

  phases = [ "unpackPhase" "patchPhase" "installPhase" ];

  patchPhase = ''
    substituteInPlace facedetect \
      --replace /usr/share/opencv "${python2Packages.opencv}/share/OpenCV"
  '';

  installPhase = ''
    install -v -m644 -D README.rst $out/share/doc/${name}/README.rst
    install -v -m755 -D facedetect $out/bin/facedetect
    wrapPythonPrograms
  '';

  meta = with stdenv.lib; {
    homepage = https://www.thregr.org/~wavexx/software/facedetect/;
    description = "A simple face detector for batch processing";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
