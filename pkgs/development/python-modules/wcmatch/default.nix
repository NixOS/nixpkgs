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
  version = "12.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Tqas73W2V79xrI+pUgFlv1rlUSDE5lWJWlt9TGmJbF4=";
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
