{ lib
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "spacy-legacy";
  version = "3.0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-T33LxObI6MtOrbsAn5wKGipnRC4AMsjWd2yUcMN1mQM=";
  };

  # checkInputs = [ pytestCheckHook spacy ];
  doCheck = false;
  pythonImportsCheck = [ "spacy_legacy" ];

  meta = with lib; {
    description = "Legacy registered functions for spaCy backwards compatibility";
    homepage = "https://github.com/justindujardin/pathy";
    license = licenses.asl20;
    maintainers = with maintainers; [ melling ];
  };
}
