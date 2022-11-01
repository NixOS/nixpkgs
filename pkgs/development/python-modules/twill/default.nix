{ lib
, buildPythonPackage
, fetchPypi
, lxml
, requests
, pyparsing
, pythonOlder
}:

buildPythonPackage rec {
  pname = "twill";
  version = "3.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tWcZRvBvkRyQ7gD5zjocBzFVlzQ0Mhf1unF3gUkhB94=";
  };

  propagatedBuildInputs = [
    lxml
    requests
    pyparsing
  ];

  pythonImportsCheck = [
    "twill"
  ];

  # pypi package comes without tests, other homepage does not provide all verisons
  doCheck = false;

  meta = with lib; {
    description = "A simple scripting language for Web browsing";
    homepage = "https://twill-tools.github.io/twill/";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
  };
}
