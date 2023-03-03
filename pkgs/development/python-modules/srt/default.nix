{ lib
, buildPythonPackage
, fetchPypi
, hypothesis
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "srt";
  version = "3.5.2";

  disabled = pythonOlder "2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7aa4ad5ce4126d3f53b3e7bc4edaa86653d0378bf1c0b1ab8c59f5ab41384450";
  };

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "srt" ];

  meta = with lib; {
    homepage = "https://github.com/cdown/srt";
    description = "A tiny but featureful Python library for parsing, modifying, and composing SRT files";
    license = licenses.bsd3;
    maintainers = with maintainers; [ friedelino ];
  };
}
