{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  setuptools,
  wheel,
  pandas,
  cloudpickle,
  coolname,
  loguru,
  psutil,
  tabulate,
  typer,
  xxhash,
}:

buildPythonPackage rec {
  pname = "xetrack";
  version = "0.4.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ABgXA9p3KkhsXHbHWFBUB0G+rqqZcu8QuKj65oSOAYA=";
  };

  build-system = [
    poetry-core
    setuptools
    wheel
  ];

  dependencies = [
    pandas
    cloudpickle
    coolname
    loguru
    psutil
    tabulate
    typer
    xxhash
  ];

  pythonImportsCheck = [ "xetrack" ];

  meta = {
    description = "Lightweight experiment tracking using a local DuckDB or CSV";
    homepage = "https://pypi.org/project/xetrack/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ brantes ];
  };
}
