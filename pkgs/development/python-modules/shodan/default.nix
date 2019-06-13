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
  version = "1.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06z9h5vxrvqns3yr4jfrxifw0iqdn6ijlnznpmyi8nc18h8yma2a";
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
