{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit,
}:

buildPythonPackage rec {
  pname = "tidyexc";
  version = "0.10.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BkcviJSigvlE5qECxfbFpYu2gVidWLvheVw5BWOVgb4=";
  };

  nativeBuildInputs = [ flit ];

  pythonImportsCheck = [ "tidyexc" ];

  meta = {
    description = "Raise rich, helpful exceptions";
    homepage = "https://github.com/kalekundert/tidyexc";
    changelog = "https://github.com/kalekundert/tidyexc/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jpetrucciani ];
  };
}
