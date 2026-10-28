{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytest,
}:

buildPythonPackage (finalAttrs: {
  pname = "whichcraft";
  version = "0.6.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-rNu5G2PWoV771kMNHXstNuRKcWl+k+Gbfe1Hev2fzoc=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = {
    homepage = "https://github.com/pydanny/whichcraft";
    description = "Cross-platform cross-python shutil.which functionality";
    changelog = "https://github.com/cookiecutter/whichcraft/blob/${finalAttrs.version}/HISTORY.rst";
    license = lib.licenses.bsd3;
  };
})
