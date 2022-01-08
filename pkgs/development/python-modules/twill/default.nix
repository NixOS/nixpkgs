{ lib, buildPythonPackage, fetchPypi, nose
, lxml
, requests
, pyparsing
}:
buildPythonPackage rec {
  pname = "twill";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "57cde4c3a2265f1a14d80007aa4f66c2135d509555499e9b156d2b4cf5048c2c";
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
