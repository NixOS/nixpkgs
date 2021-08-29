{ lib, buildPythonPackage, fetchPypi, isPy27
, Babel
, cssselect
, dateutil
, feedparser
, futures ? null
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
  pname = "weboob";
  version = "2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c69vzf8sg8471lcaafpz9iw2q3rfj5hmcpqrs2k59fkgbvy32zw";
  };

  postPatch = ''
    # Disable doctests that require networking:
    sed -i -n -e '/^ *def \+pagination *(.*: *$/ {
      p; n; p; /"""\|'\'\'\'''/!b

      :loop
      n; /^ *\(>>>\|\.\.\.\)/ { h; bloop }
      x; /^ *\(>>>\|\.\.\.\)/bloop; x
      p; /"""\|'\'\'\'''/b
      bloop
    }; p' weboob/browser/browsers.py weboob/browser/pages.py
  '';

  checkInputs = [ nose ];

  nativeBuildInputs = [ pyqt5 ];

  propagatedBuildInputs = [
    Babel
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

  meta = {
    homepage = "http://weboob.org";
    description = "Collection of applications and APIs to interact with websites without requiring the user to open a browser";
    license = lib.licenses.agpl3;
  };
}
