{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  zopfli,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "zopfli";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qO6ZKyVJ4JDNPwF4v2Bt1Bop4GE6BM31BUIkZixy3OY=";
  };

  pyproject = true;

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ zopfli ];
  USE_SYSTEM_ZOPFLI = "True";

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "CPython bindings for zopfli";
    homepage = "https://github.com/obp/py-zopfli";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
}
