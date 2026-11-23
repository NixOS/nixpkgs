{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "zodbpickle";
  version = "4.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9mt+3Ck8P3He3Z+RgclszstYNWD1Ey3g+/0HJ7n26qE=";
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
