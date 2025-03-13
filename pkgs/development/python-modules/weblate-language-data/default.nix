{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  translate-toolkit,
}:

buildPythonPackage rec {
  pname = "weblate-language-data";
  version = "2025.2";
  pyproject = true;

  src = fetchPypi {
    pname = "weblate_language_data";
    inherit version;
    hash = "sha256-T3O107CQ01loE68vlQtcCjeytxCSiu0m5Oj5P06z2NU=";
  };

  build-system = [ setuptools ];

  dependencies = [ translate-toolkit ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "weblate_language_data" ];

  meta = with lib; {
    description = "Language definitions used by Weblate";
    homepage = "https://github.com/WeblateOrg/language-data";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
  };

}
