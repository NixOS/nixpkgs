{ lib, buildPythonPackage, fetchPypi, isPy3k, nose
, lxml
, requests
, pyparsing
}:
buildPythonPackage rec {
  pname = "twill";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "85bc45bc34e3d4116123e3021c07d3a86b5e67be1ee01bc8062288eb83ae7799";
  };

  checkInputs = [ nose ];

  requiredPythonModules = [
    lxml
    requests
    pyparsing
  ];

  doCheck = false; # pypi package comes without tests, other homepage does not provide all verisons

  meta = with lib; {
    homepage = "https://twill-tools.github.io/twill/";
    description = "A simple scripting language for Web browsing";
    license     = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
  };
}
