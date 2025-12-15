{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "simple-rlp";
  version = "0.1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LfHSt2nwoBd9JiMauL4W5l41RrF7sKmkkO/TUXwIKHY=";
  };

  pythonImportsCheck = [ "rlp" ];

  meta = {
    description = "Simple RLP (Recursive Length Prefix)";
    homepage = "https://github.com/SamuelHaidu/simple-rlp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
