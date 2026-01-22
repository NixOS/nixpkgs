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
  version = "0.2.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-28mEG+3XNgQeteaYLNktqTvuFFdF9UIvN5X28ljNxu8=";
    extension = "zip";
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
