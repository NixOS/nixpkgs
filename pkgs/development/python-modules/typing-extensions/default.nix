{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "typing-extensions";
  version = "4.12.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "typing_extensions";
    inherit version;
    hash = "sha256-jLzchgbryw2VRTrX3FBl5iN7aqIwox6B0PRAww/tX9g=";
  };

  nativeBuildInputs = [ flit-core ];

  # Tests are not part of PyPI releases. GitHub source can't be used
  # as it ends with an infinite recursion
  doCheck = false;

  pythonImportsCheck = [ "typing_extensions" ];

  meta = with lib; {
    description = "Backported and Experimental Type Hints for Python";
    changelog = "https://github.com/python/typing_extensions/blob/${version}/CHANGELOG.md";
    homepage = "https://github.com/python/typing";
    license = licenses.psfl;
    maintainers = with maintainers; [ pmiddend ];
  };
}
