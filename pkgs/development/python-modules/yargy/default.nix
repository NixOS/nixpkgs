{ lib
, buildPythonPackage
, fetchPypi
, pymorphy2
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "yargy";
  version = "0.16.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yRfu+zKkDCPEa2yojWiScHLdAKuU6Q/V3GqwpitZtZM=";
  };

  propagatedBuildInputs = [ pymorphy2 ];
  pythonImportCheck = [ "yargy" ];
  nativeCheckInputs = [ pytestCheckHook ];
  pytestFlagsArray = [ "tests" ];

  meta = with lib; {
    description = "Rule-based facts extraction for Russian language";
    homepage = "https://github.com/natasha/yargu";
    license = licenses.mit;
    maintainers = with maintainers; [ npatsakula ];
  };
}
