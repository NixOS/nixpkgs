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
  version = "10.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5y8N4Ju6agTg3nCTewzwblXzbzez3rQi36+FS4Z7hAo=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [ bracex ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [ "TestTilde" ];

  pythonImportsCheck = [ "wcmatch" ];

  meta = with lib; {
    description = "Wilcard File Name matching library";
    homepage = "https://github.com/facelessuser/wcmatch";
    license = licenses.mit;
    maintainers = [ ];
  };
}
