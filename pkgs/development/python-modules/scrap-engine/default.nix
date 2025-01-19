{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "scrap-engine";
  version = "1.4.1";
  pyproject = true;

  src = fetchPypi {
    pname = "scrap_engine";
    inherit version;
    hash = "sha256-qxzbVYFcSKcL2HtMlH9epO/sCx9HckWAt/NyVD8QJBQ=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonImportsCheck = [ "scrap_engine" ];

  # raise scrap_engine.CoordinateError
  doCheck = false;

  meta = {
    maintainers = with lib.maintainers; [ fgaz ];
    description = "2D ascii game engine for the terminal";
    homepage = "https://github.com/lxgr-linux/scrap_engine";
    license = lib.licenses.gpl3Only;
  };
}
