{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "striprtf";
  version = "0.0.22";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-T7rb6EJPQStbJjv3L7PA2rTdtXTWCd1NCE9uK4sEQCs=";
  };

  pythonImportsCheck = [
    "striprtf"
  ];

  meta = with lib; {
    homepage = "https://github.com/joshy/striprtf";
    description = "A simple library to convert rtf to text";
    maintainers = with maintainers; [ aanderse ];
    license = with licenses; [ bsd3 ];
  };
}
