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
  version = "8.5.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pwIiuG3qgvs4Ldh7cyeMEHVsE4vW+PcU4hgxKIh7nrI=";
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
    maintainers = with maintainers; [ ];
  };
}
