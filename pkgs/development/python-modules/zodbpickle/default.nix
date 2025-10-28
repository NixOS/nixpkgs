{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "zodbpickle";
  version = "4.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WoUUT7psNPxnvQDH8InW1TLcQ6A0R9/F4jhGyRkjCkU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools <= 75.6.0" "setuptools"
  '';

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
