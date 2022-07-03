{ lib, buildPythonPackage, fetchPypi, pythonOlder, setuptools-scm, zopfli, pytestCheckHook }:

buildPythonPackage rec {
  pname = "zopfli";
  version = "0.2.1";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ipjkcgdbplsrhr31ypk48px8cax4cm9gcjj7yrcrhg20ql3s9p5";
    extension = "zip";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ zopfli ];
  USE_SYSTEM_ZOPFLI = "True";

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "cPython bindings for zopfli";
    homepage = "https://github.com/obp/py-zopfli";
    license = licenses.asl20;
    maintainers = [ maintainers.sternenseemann ];
  };
}
