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
  version = "4.1.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-38DJFe8Umd0GA5cPXBECxr1+t7asRkNLKabYQL8Cckg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "setuptools<74" "setuptools"
  '';

  build-system = [ setuptools ];

  pythonImportsCheck = [ "zodbpickle" ];

  nativeCheckInputs = [ pytestCheckHook ];

  # fails..
  disabledTests = [
    "test_dump"
    "test_dumps"
    "test_load"
    "test_loads"
  ];

  meta = with lib; {
    description = "Fork of Python's pickle module to work with ZODB";
    homepage = "https://github.com/zopefoundation/zodbpickle";
    changelog = "https://github.com/zopefoundation/zodbpickle/blob/${version}/CHANGES.rst";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
