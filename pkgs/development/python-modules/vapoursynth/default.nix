{ vapoursynth, cython, buildPythonPackage, python }:

buildPythonPackage {
  pname = "vapoursynth";

  inherit (vapoursynth) version src;

  nativeBuildInputs = [
    cython
  ];

  buildInputs = [
    vapoursynth
  ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s $src/test -p "*test.py"
  '';

  inherit (vapoursynth) meta;
}

