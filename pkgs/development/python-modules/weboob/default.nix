{ buildPythonPackage, fetchurl, fetchPypi, stdenv, isPy27
, nose, pillow, prettytable, pyyaml, dateutil, gdata
, requests, mechanize, feedparser, lxml, gnupg, pyqt5
, libyaml, simplejson, cssselect, futures, pdfminer
, termcolor, google_api_python_client, html2text
, unidecode
}:

let
  # Support for Python 2.7 was dropped in 1.7.7
  google_api_python_client_python27 = google_api_python_client.overrideDerivation
    (oldAttrs: rec {
      pname = "google-api-python-client";
      version = "1.7.6";
      src = fetchPypi {
        inherit pname version;
        sha256 = "14w5sdrp0bk9n0r2lmpqmrbf2zclpfq6q7giyahnskkfzdkb165z";
      };
    });
in buildPythonPackage rec {
  pname = "weboob";
  version = "1.3";
  disabled = ! isPy27;

  src = fetchurl {
    url = "https://symlink.me/attachments/download/356/${pname}-${version}.tar.gz";
    sha256 = "0m5yh49lplvb57dfilczh65ky35fshp3g7ni31pwfxwqi1f7i4f9";
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

  propagatedBuildInputs = [ pillow prettytable pyyaml dateutil
    gdata requests mechanize feedparser lxml gnupg pyqt5 libyaml
    simplejson cssselect futures pdfminer termcolor
    google_api_python_client_python27 html2text unidecode ];

  checkPhase = ''
    nosetests
  '';

  meta = {
    homepage = http://weboob.org;
    description = "Collection of applications and APIs to interact with websites without requiring the user to open a browser";
    license = stdenv.lib.licenses.agpl3;
  };
}

