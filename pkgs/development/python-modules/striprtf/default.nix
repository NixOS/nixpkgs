{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "striprtf";
  version = "0.0.20";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8eMeMrazl1o9XcIyWICDg6ycRMtFMfgTUNz51w9hAmc=";
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
