{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  translate-toolkit,
}:

buildPythonPackage rec {
  pname = "weblate-language-data";
<<<<<<< HEAD
  version = "2025.10";
=======
  version = "2025.9";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    pname = "weblate_language_data";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-pSMeuIDUGYbAetXugmahtTeGIIXxPPPiYt2Jb80vxoQ=";
=======
    hash = "sha256-sk53eGLPSfYoe4+BExIxINkFt/vcvkIIO5611hwx9uU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [ translate-toolkit ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "weblate_language_data" ];

<<<<<<< HEAD
  meta = {
    description = "Language definitions used by Weblate";
    homepage = "https://github.com/WeblateOrg/language-data";
    changelog = "https://github.com/WeblateOrg/language-data/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ erictapen ];
=======
  meta = with lib; {
    description = "Language definitions used by Weblate";
    homepage = "https://github.com/WeblateOrg/language-data";
    changelog = "https://github.com/WeblateOrg/language-data/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

}
