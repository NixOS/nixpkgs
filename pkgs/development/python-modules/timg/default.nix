{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pillow,
}:

buildPythonPackage rec {
  pname = "timg";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wmfbimnGQZzjAhCAwd1DFQzdCf9V7lTCuMF65eDkd8E=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pillow
  ];

  pythonImportsCheck = [
    "timg"
  ];

  meta = {
    description = "Display an image in terminal";
    homepage = "https://github.com/adzierzanowski/timg";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      euxane
      renesat
    ];
  };
}
