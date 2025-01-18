{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  translate-toolkit,
}:

buildPythonPackage rec {
  pname = "weblate-language-data";
  version = "2024.6";
  pyproject = true;

  src = fetchPypi {
    pname = "weblate_language_data";
    inherit version;
    hash = "sha256-FGLrjptIqMeKAV/O2H6ZcP+uGcr1ghqIxAHsYnOpVxg=";
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
