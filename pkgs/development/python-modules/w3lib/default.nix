{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
<<<<<<< HEAD
, pythonAtLeast
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "w3lib"
  ];

<<<<<<< HEAD
  disabledTests = lib.optionals (pythonAtLeast "3.11") [
    # regressed on Python 3.11.4
    # https://github.com/scrapy/w3lib/issues/212
    "test_safe_url_string_url"
=======
  disabledTests = [
    "test_add_or_replace_parameter"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "Library of web-related functions";
    homepage = "https://github.com/scrapy/w3lib";
    changelog = "https://github.com/scrapy/w3lib/blob/v${version}/NEWS";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
