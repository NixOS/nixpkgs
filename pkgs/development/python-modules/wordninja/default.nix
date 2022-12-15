{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "wordninja";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-GhzH7BRq0Z1vcZQe6CrvPTEiFwDw2L+EQTbPjfedKBo=";
  };

  doCheck = false;
  propagatedBuildInputs = [
  ];

  meta = with lib; {
    homepage = "https://github.com/keredson/wordninja";
    description = "Probabilistically split concatenated words using NLP based on English Wikipedia unigram frequencies";
    license = licenses.mit;
  };
}
