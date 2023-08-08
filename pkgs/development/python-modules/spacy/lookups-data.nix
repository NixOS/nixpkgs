{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, spacy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "spacy-lookups-data";
  version = "1.0.5";
  format = "setuptools";

  src = fetchPypi {
    pname = "spacy_lookups_data";
    inherit version;
    hash = "sha256-b5NcgfFFvcyE/GEV9kh2QoXH/z6P8kYpUEaBTpba1jw=";
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
