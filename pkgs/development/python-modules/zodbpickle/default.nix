{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "zodbpickle";
  version = "4.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Z9QpXdtoskEP5BcJT/4aiw7UGDTuMIAg9Y7htjPh91E=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "zodbpickle" ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    mv src/zodbpickle/tests ./.
    rm -rf src
  '';

  # fails..
  disabledTests = [
    "test_dump"
    "test_dumps"
    "test_load"
    "test_loads"
  ];

  meta = {
    description = "Fork of Python's pickle module to work with ZODB";
    homepage = "https://github.com/zopefoundation/zodbpickle";
    changelog = "https://github.com/zopefoundation/zodbpickle/blob/${version}/CHANGES.rst";
    license = with lib.licenses; [
      psfl
      zpl21
    ];
    maintainers = [ ];
  };
}
