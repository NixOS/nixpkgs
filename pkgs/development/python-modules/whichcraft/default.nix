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
    sha256 = "11yfkzyplizdgndy34vyd5qlmr1n5mxis3a3svxmx8fnccdvknxc";
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
