{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pillow,
}:

buildPythonPackage rec {
  pname = "timg";
  version = "1.1.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-k42TmsNQIwD3ueParfXaD4jFuG/eWILXO0Op0Ci9S/0=";
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
