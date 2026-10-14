{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  django,
}:

buildPythonPackage rec {
  pname = "sorl-thumbnail";
  version = "13.2.0";
  pyproject = true;

  src = fetchPypi {
    pname = "sorl_thumbnail";
    inherit version;
    hash = "sha256-866amXSFsxbUpEwtm/FusKtKokXGvnQ+XTSnKOqrWd0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [ django ];

  env.DJANGO_SETTINGS_MODULE = "sorl.thumbnail.conf.defaults";

  # Disabled due to an improper configuration error when tested against django. This looks like something broken in the test cases for sorl.
  doCheck = false;

  pythonImportsCheck = [ "sorl.thumbnail" ];

  meta = {
    homepage = "https://sorl-thumbnail.readthedocs.org/en/latest/";
    description = "Thumbnails for Django";
    changelog = "https://github.com/jazzband/sorl-thumbnail/blob/${version}/CHANGES.rst";
    license = lib.licenses.bsd3;
  };
}
