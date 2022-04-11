{ lib, buildPythonPackage, fetchPypi, nose
, lxml
, requests
, pyparsing
}:
buildPythonPackage rec {
  pname = "twill";
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-dWtrdkiR1+IBfeF9jwbOjKE2UMXDJji0iOb+USbY7zk=";
  };

  checkInputs = [ nose ];

  propagatedBuildInputs = [
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
