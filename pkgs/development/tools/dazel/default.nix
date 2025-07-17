{
  lib,
  buildPythonApplication,
  fetchPypi,
}:
buildPythonApplication rec {
  version = "0.0.42";
  format = "setuptools";
  pname = "dazel";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JE7+GS7DpuFoC2LK3dvYvjtOdzRxFMHzgZRfvrGBDtQ=";
  };

  meta = {
    homepage = "https://github.com/nadirizr/dazel";
    description = "Run Google's bazel inside a docker container via a seamless proxy.";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      malt3
    ];
  };
}
