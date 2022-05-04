{ lib
, Babel
, buildPythonPackage
, colorama
, cssselect
, feedparser
, fetchFromGitLab
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
, python-dateutil
, pythonOlder
, pyyaml
, requests
, simplejson
, termcolor
, unidecode
}:

buildPythonPackage rec {
  pname = "woob";
  version = "3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    owner = "woob";
    repo = pname;
    rev = version;
    hash = "sha256-XLcHNidclORbxVXgcsHY6Ja/dak+EVSKTaVQmg1f/rw=";
  };

  nativeBuildInputs = [
    pyqt5
  ];

  propagatedBuildInputs = [
    Babel
    colorama
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
    pdfminer
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
      --replace "with-coverage = 1" ""
  '';

  checkInputs = [
    nose
  ];

  checkPhase = ''
    nosetests
  '';

  pythonImportsCheck = [
    "woob"
  ];

  meta = with lib; {
    description = "Collection of applications and APIs to interact with websites";
    homepage = "https://woob.tech";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ DamienCassou ];
  };
}
