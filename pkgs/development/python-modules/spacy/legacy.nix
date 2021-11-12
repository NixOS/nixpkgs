{ lib
, fetchPypi
, buildPythonPackage
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "spacy-legacy";
  version = "3.0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b4725c5c161f0685ab4fce3fc912bc68aefdb7e102ba9848e852bb5842256c2f";
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
