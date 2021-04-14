{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, Babel
, colorama
, cssselect
, dateutil
, feedparser
, futures
, gdata
, gnupg
, google-api-python-client
, html2text
, libyaml
, lxml
, mechanize
, nose
, pdfminer
, pillow
, prettytable
, pyqt5
, pyyaml
, requests
, simplejson
, termcolor
, unidecode
}:

buildPythonPackage rec {
  pname = "woob";
  version = "3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09hpxy5zhn2b8li0xjf3zd7s46lawb0315p5mdcsci3bj3s4v1j7";
  };

  patches = [
    # Disable doctests that require networking:
    ./no-test-requiring-network.patch
  ];

  checkInputs = [ nose ];

  nativeBuildInputs = [ pyqt5 ];

  propagatedBuildInputs = [
    Babel
    colorama
    cssselect
    dateutil
    feedparser
    gdata
    gnupg
    google-api-python-client
    html2text
    libyaml
    lxml
    mechanize
    pdfminer
    pillow
    prettytable
    pyqt5
    pyyaml
    requests
    simplejson
    termcolor
    unidecode
  ] ++ lib.optionals isPy27 [ futures ];

  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    homepage = "https://woob.tech";
    description = "Collection of applications and APIs to interact with websites without requiring the user to open a browser";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.DamienCassou ];
 };
}
