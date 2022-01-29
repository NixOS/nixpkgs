{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "striprtf";
  version = "0.0.19";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b7f15e11306e466dbe91665409233a06d9fdb4ee156489a3d879579891b04c25";
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
