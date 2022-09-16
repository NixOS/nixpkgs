{ vapoursynth, cython, buildPythonPackage, unittestCheckHook, python }:

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

  passthru = {
    withPlugins = plugins:
      python.pkgs.vapoursynth.override {
        vapoursynth = vapoursynth.withPlugins plugins;
      };
  };

  inherit (vapoursynth) meta;
}

