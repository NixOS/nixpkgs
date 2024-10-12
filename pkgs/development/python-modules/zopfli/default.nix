{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools-scm,
  zopfli,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "zopfli";
  version = "0.2.3";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-28mEG+3XNgQeteaYLNktqTvuFFdF9UIvN5X28ljNxu8=";
    extension = "zip";
  };

  format = "pyproject";

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ zopfli ];
  USE_SYSTEM_ZOPFLI = "True";

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "cPython bindings for zopfli";
    homepage = "https://github.com/obp/py-zopfli";
    license = licenses.asl20;
    maintainers = [ maintainers.sternenseemann ];
  };
}
