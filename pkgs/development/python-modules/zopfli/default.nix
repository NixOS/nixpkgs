{ lib, buildPythonPackage, fetchPypi, setuptools-scm, zopfli, pytest }:

buildPythonPackage rec {
  pname = "zopfli";
  version = "0.1.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "78de3cc08a8efaa8013d61528907d91ac4d6cc014ffd8a41cc10ee75e9e60d7b";
    extension = "zip";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ zopfli ];
  USE_SYSTEM_ZOPFLI = "True";

  # doesn't work with pytestCheckHook
  checkInputs = [ pytest ];

  meta = with lib; {
    description = "cPython bindings for zopfli";
    homepage = "https://github.com/obp/py-zopfli";
    license = licenses.asl20;
    maintainers = [ maintainers.sternenseemann ];
  };
}
