{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "simp-sexp";
  version = "0.3.1";
  pyproject = true;

  src = fetchPypi {
    pname = "simp_sexp";
    inherit (finalAttrs) version;
    hash = "sha256-/oX60pEHmrW8oYHCKCguJbwN9wdBwN7lk6Qha4eYC1o=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "simp_sexp" ];

  meta = {
    description = "Simple S-expression parser";
    homepage = "https://github.com/devbisme/simp_sexp";
    changelog = "https://github.com/devbisme/simp_sexp/blob/v${finalAttrs.version}/HISTORY.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
