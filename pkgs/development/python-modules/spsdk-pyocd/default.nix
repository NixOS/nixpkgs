{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  pyocd,
  pyocd-pemicro,
  spsdk,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,

  # passthru
  spsdk-pyocd,
}:

buildPythonPackage rec {
  pname = "spsdk-pyocd";
  version = "0.3.4";
  pyproject = true;

  # Latest tag missing on GitHub
  src = fetchPypi {
    pname = "spsdk_pyocd";
    inherit version;
    hash = "sha256-jvzXu6z9oo2oGoiDgCWWcU3yX/PuWm56MJzIcMWCgTM=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "pyocd"
  ];

  dependencies = [
    pyocd
  ];

  optional-dependencies = {
    pemicro = [
      pyocd-pemicro
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    spsdk
    writableTmpDirAsHomeHook
  ];

  # Cyclic dependency with spsdk
  doCheck = false;

  passthru.tests = {
    pytest = spsdk-pyocd.overridePythonAttrs {
      pythonImportsCheck = [ "spsdk_pyocd" ];

      doCheck = true;
    };
  };

  meta = {
    description = "Debugger probe plugin for SPSDK";
    homepage = "https://pypi.org/project/spsdk-pyocd";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
