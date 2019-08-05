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
  version = "1.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c5x53757p6ihh1f8xqsal2gi9ikcl3464b38qinva51s0kkb58k";
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
