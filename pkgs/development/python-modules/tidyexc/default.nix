{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  flit,
}:

buildPythonPackage rec {
  pname = "tidyexc";
  version = "0.10.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BkcviJSigvlE5qECxfbFpYu2gVidWLvheVw5BWOVgb4=";
  };

  nativeBuildInputs = [ flit ];

  pythonImportsCheck = [ "tidyexc" ];

  meta = with lib; {
    description = "Raise rich, helpful exceptions";
    homepage = "https://github.com/kalekundert/tidyexc";
    changelog = "https://github.com/kalekundert/tidyexc/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
