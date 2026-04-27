{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-webencodings";
  version = "0.5.0.20251108";
  pyproject = true;

  src = fetchPypi {
    pname = "types_webencodings";
    inherit version;
    hash = "sha256-I3jizszO09QbteITh1hue1MF4RUZ/GsGWcYp8jsuXeQ=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "webencodings-stubs" ];

  meta = {
    description = "Typing stubs for webencodings";
    homepage = "https://pypi.org/project/types-webencodings/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
