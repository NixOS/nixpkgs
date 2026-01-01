{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  sphinx,
  sphinxHook,
}:

buildPythonPackage rec {
  pname = "sphinxemoji";
<<<<<<< HEAD
  version = "0.3.2";
=======
  version = "0.3.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "pyproject";

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "sphinx-contrib";
    repo = "emojicodes";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-2/2fOIxjF4vs90uqZyzfidrh+P/MHa+LTf1RsQYmgZ0=";
=======
    hash = "sha256-ss7snuXyT+tahc2GioB7qdGDqZdajEGdbaNt0aWF9ls=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    setuptools
    sphinxHook
  ];

  propagatedBuildInputs = [
    sphinx
    # sphinxemoji.py imports pkg_resources directly
    setuptools
  ];

  pythonImportsCheck = [ "sphinxemoji" ];

<<<<<<< HEAD
  meta = {
    description = "Extension to use emoji codes in your Sphinx documentation";
    homepage = "https://github.com/sphinx-contrib/emojicodes";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kaction ];
=======
  meta = with lib; {
    description = "Extension to use emoji codes in your Sphinx documentation";
    homepage = "https://github.com/sphinx-contrib/emojicodes";
    license = licenses.mit;
    maintainers = with maintainers; [ kaction ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
