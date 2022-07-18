{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "simple-rlp";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5c4a9c58f1b742f7fa8af0fe4ea6ff9fb02294ae041912f771570dfaf339d2b9";
  };

  pythonImportsCheck = [ "rlp" ];

  meta = with lib; {
    description = "Simple RLP (Recursive Length Prefix)";
    homepage = "https://github.com/SamuelHaidu/simple-rlp";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
