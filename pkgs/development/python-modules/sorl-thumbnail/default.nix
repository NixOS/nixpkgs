{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  django,
}:

buildPythonPackage (finalAttrs: {
  pname = "sorl-thumbnail";
  version = "12.11.0";
  pyproject = true;

  src = fetchPypi {
    pname = "sorl_thumbnail";
    inherit (finalAttrs) version;
    hash = "sha256-GRuJwn7LQLXCo1VJ1VfRfEhBxq/0ObLhe5OLke6kY7M=";
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
    changelog = "https://github.com/jazzband/sorl-thumbnail/blob/${finalAttrs.version}/CHANGES.rst";
    license = lib.licenses.bsd3;
  };
})
