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
  version = "1.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kjcyw3xmps3maf4vzn1pypc6i60q8b67xj78v4gbv4yx2cp2fzr";
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
