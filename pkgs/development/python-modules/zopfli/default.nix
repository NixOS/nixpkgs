{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  zopfli,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "zopfli";
  version = "0.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-qO6ZKyVJ4JDNPwF4v2Bt1Bop4GE6BM31BUIkZixy3OY=";
  };

  build-system = [ setuptools-scm ];

  buildInputs = [ zopfli ];

  env.USE_SYSTEM_ZOPFLI = "True";

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "CPython bindings for zopfli";
    homepage = "https://github.com/obp/py-zopfli";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
})
