{ lib, buildPythonPackage, fetchPypi, isPy3k, nose
, lxml
, requests
, pyparsing
}:
buildPythonPackage rec {
  pname = "twill";
  version = "2.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fc694ac1cb0616cfba2f9db4720e9d354bf656c318e21ef604a7e3caaef83d10";
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
