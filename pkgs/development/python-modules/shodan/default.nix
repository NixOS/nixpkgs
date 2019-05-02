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
  version = "1.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fd68yaqhpay7jxhyc6xkdrak88wdblxs0phgdkngbakx2yaw2y3";
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
