{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "w3lib";
  version = "2.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DhGY8bdFGVtrPdGkzWYBH7+C8wpNnauu4fnlyG8CAnQ=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "w3lib"
  ];

  disabledTests = [
    "test_add_or_replace_parameter"
  ];

  meta = with lib; {
    description = "Library of web-related functions";
    homepage = "https://github.com/scrapy/w3lib";
    changelog = "https://github.com/scrapy/w3lib/blob/v${version}/NEWS";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
