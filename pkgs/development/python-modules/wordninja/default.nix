{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "wordninja";
  version = "2.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-GhzH7BRq0Z1vcZQe6CrvPTEiFwDw2L+EQTbPjfedKBo=";
  };

  propagatedBuildInputs = [ ];

  pythonImportsCheck = [ "wordninja" ];

  meta = with lib; {
    description = "Probabilistically split concatenated words using NLP based on English Wikipedia uni-gram frequencies";
    homepage = "https://github.com/keredson/wordninja";
    license = licenses.mit;
    maintainers = with maintainers; [ provenzano ];
  };
}
