{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "tag-expressions";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/6Ym72jlgVdpel4V2W2aCKNtISDT9y5qz7+gTllUuPg=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "tagexpressions"
  ];

  meta = with lib; {
    description = "Package to parse logical tag expressions";
    homepage = "https://github.com/timofurrer/tag-expressions";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kalbasit ];
  };
}
