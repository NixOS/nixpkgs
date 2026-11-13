{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "simp-sexp";
  version = "0.3.2";
  pyproject = true;

  src = fetchPypi {
    pname = "simp_sexp";
    inherit (finalAttrs) version;
    hash = "sha256-Xo7inlsq4sdyec8OdgFP+uIaVLV7ExWgcAnn1PjkEgs=";
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
