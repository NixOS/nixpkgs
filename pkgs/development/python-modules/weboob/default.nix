{ lib
, babel
, buildPythonPackage
, cssselect
, feedparser
, fetchPypi
, gdata
, gnupg
, google-api-python-client
, html2text
, libyaml
, lxml
, mechanize
, nose
, pdfminer-six
, pillow
, prettytable
, pyqt5
, pytestCheckHook
, python-dateutil
, pythonOlder
, pyyaml
, requests
, simplejson
, termcolor
, unidecode
}:

buildPythonPackage rec {
  pname = "weboob";
  version = "2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c69vzf8sg8471lcaafpz9iw2q3rfj5hmcpqrs2k59fkgbvy32zw";
  };

  nativeBuildInputs = [
    pyqt5
  ];

  propagatedBuildInputs = [
    babel
    cssselect
    python-dateutil
    feedparser
    gdata
    gnupg
    google-api-python-client
    html2text
    libyaml
    lxml
    mechanize
    pdfminer-six
    pillow
    prettytable
    pyqt5
    pyyaml
    requests
    simplejson
    termcolor
    unidecode
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "with-doctest = 1" "" \
      --replace "with-coverage = 1" "" \
      --replace "weboob.browser.filters.standard," "" \
      --replace "weboob.browser.tests.filters," "" \
      --replace "weboob.tools.application.formatters.json," "" \
      --replace "weboob.tools.application.formatters.table," "" \
      --replace "weboob.tools.capabilities.bank.transactions," ""
  '';

  checkInputs = [
    nose
  ];

  checkPhase = ''
    nosetests
  '';

  pythonImportsCheck = [
    "weboob"
  ];

  meta = with lib; {
    description = "Collection of applications and APIs to interact with websites";
    homepage = "http://weboob.org";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
