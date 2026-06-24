{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "simp-sexp";
  version = "0.3.1";
  pyproject = true;

  src = fetchPypi {
    pname = "simp_sexp";
    inherit version;
    hash = "sha256-/oX60pEHmrW8oYHCKCguJbwN9wdBwN7lk6Qha4eYC1o=";
  };

  build-system = [
    setuptools
    wheel
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "simp_sexp" ];

  meta = {
    description = "Simple S-expression parser";
    homepage = "https://github.com/devbisme/simp_sexp";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
