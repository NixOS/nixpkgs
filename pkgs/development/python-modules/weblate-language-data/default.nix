{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  translate-toolkit,
}:

buildPythonPackage rec {
  pname = "weblate-language-data";
  version = "2025.9";
  pyproject = true;

  src = fetchPypi {
    pname = "weblate_language_data";
    inherit version;
    hash = "sha256-sk53eGLPSfYoe4+BExIxINkFt/vcvkIIO5611hwx9uU=";
  };

  build-system = [ setuptools ];

  dependencies = [ translate-toolkit ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "weblate_language_data" ];

  meta = with lib; {
    description = "Language definitions used by Weblate";
    homepage = "https://github.com/WeblateOrg/language-data";
    changelog = "https://github.com/WeblateOrg/language-data/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
  };

}
