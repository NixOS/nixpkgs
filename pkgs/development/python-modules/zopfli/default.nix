{ lib, buildPythonPackage, fetchPypi, pythonOlder, setuptools-scm, zopfli, pytestCheckHook }:

buildPythonPackage rec {
  pname = "zopfli";
  version = "0.2.2";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1z1akqx3fjnwa75insch9p08hafikqdvqkj6mxv1k6fr81sxnj9d";
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
