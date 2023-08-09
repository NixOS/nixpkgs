{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tap.py";
  version = "3.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3c0cd45212ad5a25b35445964e2517efa000a118a1bfc3437dae828892eaf1e1";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "tap" ];

  meta = with lib; {
    description = "A set of tools for working with the Test Anything Protocol (TAP) in Python";
    homepage = "https://github.com/python-tap/tappy";
    changelog = "https://tappy.readthedocs.io/en/latest/releases.html";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sfrijters ];
  };
}
