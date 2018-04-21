{ buildPythonPackage, fetchurl, stdenv, isPy27
, nose, pillow, prettytable, pyyaml, dateutil, gdata
, requests, mechanize, feedparser, lxml, gnupg, pyqt5
, libyaml, simplejson, cssselect, futures, pdfminer
, termcolor, google_api_python_client, html2text
, unidecode
}:

buildPythonPackage rec {
  pname = "weboob";
  version = "1.3";
  disabled = ! isPy27;

  src = fetchurl {
    url = "https://symlink.me/attachments/download/356/${pname}-${version}.tar.gz";
    sha256 = "0m5yh49lplvb57dfilczh65ky35fshp3g7ni31pwfxwqi1f7i4f9";
  };

  setupPyBuildFlags = ["--qt" "--xdg"];

  checkInputs = [ nose ];

  propagatedBuildInputs = [ pillow prettytable pyyaml dateutil
    gdata requests mechanize feedparser lxml gnupg pyqt5 libyaml
    simplejson cssselect futures pdfminer termcolor google_api_python_client
    html2text unidecode ];

  checkPhase = ''
    nosetests
  '';

  meta = {
    homepage = http://weboob.org;
    description = "Collection of applications and APIs to interact with websites without requiring the user to open a browser";
    license = stdenv.lib.licenses.agpl3;
    broken = true; # 2018-04-11
  };
}

