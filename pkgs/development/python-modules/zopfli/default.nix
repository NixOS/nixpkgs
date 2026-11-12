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
  version = "0.4.3";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-06UPkaE86puv4CXej9h6AF6ybeAqTwwZMSfdvyOsjr4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools<72.2.0" "setuptools"
  '';

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
