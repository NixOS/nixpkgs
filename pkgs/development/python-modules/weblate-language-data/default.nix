{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  translate-toolkit,
}:

buildPythonPackage rec {
  pname = "weblate-language-data";
  version = "2024.5";
  pyproject = true;
  build-system = [ setuptools ];

  src = fetchPypi {
    pname = "weblate_language_data";
    inherit version;
    hash = "sha256-kDt5ZF8cFH6HoQVlGX+jbchbwVCUIvmxHsCY3hjtjDM=";
  };

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
