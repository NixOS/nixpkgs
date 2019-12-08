{ buildPythonPackage, fetchPypi, stdenv
, nose, pillow, prettytable, pyyaml, dateutil, gdata
, requests, mechanize, feedparser, lxml, gnupg, pyqt5
, libyaml, simplejson, cssselect, pdfminer
, termcolor, google_api_python_client, html2text
, unidecode
}:

buildPythonPackage rec {
  pname = "weboob";
  version = "1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c9z9gid1mbm1cakb2wj6jjkbrmji8y8ac46iqpih9x1h498bhbs";
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

  setupPyBuildFlags = ["--qt" "--xdg"];

  checkInputs = [ nose ];

  nativeBuildInputs = [ pyqt5 ];

  propagatedBuildInputs = [ pillow prettytable pyyaml dateutil
    gdata requests mechanize feedparser lxml gnupg pyqt5 libyaml
    simplejson cssselect pdfminer termcolor
    google_api_python_client html2text unidecode ];

  checkPhase = ''
    nosetests
  '';

  meta = {
    homepage = http://weboob.org;
    description = "Collection of applications and APIs to interact with websites without requiring the user to open a browser";
    license = stdenv.lib.licenses.agpl3;
  };
}
