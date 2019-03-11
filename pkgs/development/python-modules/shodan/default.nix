{ lib
, fetchPypi
, buildPythonPackage
, click-plugins
, colorama
, requests
, XlsxWriter
}:

buildPythonPackage rec {
  pname = "shodan";
  version = "1.10.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13966vqxww7v2b5hf2kjismdzvqyjvxlcdvpkzpbsrpxy9pvn2n4";
  };

  propagatedBuildInputs = [
    click-plugins
    colorama
    requests
    XlsxWriter
  ];

  # The tests require a shodan api key, so skip them.
  doCheck = false;

  meta = with lib; {
    description = "Python library and command-line utility for Shodan";
    homepage = https://github.com/achillean/shodan-python;
    license = licenses.mit;
    maintainers = with maintainers; [ lihop ];
  };
}
