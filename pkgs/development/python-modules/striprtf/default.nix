{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "striprtf";
  version = "0.0.21";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/wqYbdJ+OI/RTODnKB34e7zADHzCPEX0LkTausqFNtY=";
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
