{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, spacy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "spacy-lookups-data";
  version = "1.0.3";
  format = "setuptools";

  src = fetchPypi {
    pname = "spacy_lookups_data";
    inherit version;
    hash = "sha256-q2hlVI+4ZtR5CQ4xEIp+Je0ZKhH8sJiW5xFjKM3FK+E=";
  };

  nativeCheckInputs = [
    spacy
    pytestCheckHook
  ];

  pythonImportsCheck = [ "spacy_lookups_data" ];

  meta = with lib; {
    description = "Additional lookup tables and data resources for spaCy";
    homepage = "https://pypi.org/project/spacy-lookups-data";
    license = licenses.mit;
    maintainers = with maintainers; [ jboy ];
  };
}
