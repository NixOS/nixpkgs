{ vapoursynth, cython, buildPythonPackage, unittestCheckHook }:

buildPythonPackage {
  pname = "vapoursynth";

  inherit (vapoursynth) version src;

  nativeBuildInputs = [
    cython
  ];

  buildInputs = [
    vapoursynth
  ];

  checkInputs = [
    unittestCheckHook
  ];

  unittestFlagsArray = [ "-s" "$src/test" "-p" "'*test.py'" ];

  inherit (vapoursynth) meta;
}

