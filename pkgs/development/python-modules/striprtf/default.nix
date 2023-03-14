{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "striprtf";
  version = "0.0.22";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-T7rb6EJPQStbJjv3L7PA2rTdtXTWCd1NCE9uK4sEQCs=";
  };

  pythonImportsCheck = [
    "striprtf"
  ];

  meta = with lib; {
    changelog = "https://github.com/joshy/striprtf/blob/v${version}/CHANGELOG.md";
    homepage = "https://github.com/joshy/striprtf";
    description = "A simple library to convert rtf to text";
    maintainers = with maintainers; [ aanderse ];
    license = with licenses; [ bsd3 ];
  };
}
