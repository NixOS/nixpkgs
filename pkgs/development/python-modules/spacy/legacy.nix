{ lib
, fetchPypi
, buildPythonPackage
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "spacy-legacy";
  version = "3.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Uy94rjFllSj622RTzd6UJaQmIniCw4gpeq/X57QcIpA=";
  };

  # checkInputs = [ pytestCheckHook spacy ];
  doCheck = false;
  pythonImportsCheck = [ "spacy_legacy" ];

  meta = with lib; {
    description = "A Path interface for local and cloud bucket storage";
    homepage = "https://github.com/justindujardin/pathy";
    license = licenses.asl20;
    maintainers = with maintainers; [ melling ];
  };
}
