{ buildPythonPackage
, lib
, fetchPypi
, glibcLocales
, isPy3k
, pythonOlder
, pytestCheckHook
, curio
}:

buildPythonPackage rec {
  pname = "sniffio";
  version = "1.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5gMFxeXTFPU4klm38iqqM9j33uSXYxGSNK83VcVbkQE=";
  };

  disabled = !isPy3k;

  buildInputs = [
    glibcLocales
  ];

  nativeCheckInputs = [
    curio
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/python-trio/sniffio";
    license = licenses.asl20;
    description = "Sniff out which async library your code is running under";
  };
}
