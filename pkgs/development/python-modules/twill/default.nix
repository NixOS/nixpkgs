{ lib, buildPythonPackage, fetchPypi, isPy3k, nose
, lxml
, requests
, pyparsing
}:
buildPythonPackage rec {
  pname = "twill";
  version = "2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "225e114da85555d50433a1e242ed4215fe613c30072d13fbe4c4aacf0ad53b0a";
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
