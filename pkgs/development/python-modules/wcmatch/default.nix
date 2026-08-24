{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pytestCheckHook,
  bracex,
}:

buildPythonPackage rec {
  pname = "wcmatch";
  version = "10.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7KxwpccOYrqFS3gxjToUCOhlH48cluWDd0O3Gqak+5I=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [ bracex ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [ "TestTilde" ];

  pythonImportsCheck = [ "wcmatch" ];

  meta = {
    description = "Wildcard File Name matching library";
    homepage = "https://github.com/facelessuser/wcmatch";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
