{ vapoursynth, cython, buildPythonPackage, unittestCheckHook, python }:

buildPythonPackage {
  pname = "vapoursynth";
  format = "setuptools";

  inherit (vapoursynth) version src;

  nativeBuildInputs = [
    cython
  ];

  buildInputs = [
    vapoursynth
  ];

  nativeCheckInputs = [
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

