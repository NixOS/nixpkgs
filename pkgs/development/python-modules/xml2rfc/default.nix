{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, intervaltree
, pyflakes
, requests
, lxml
, google-i18n-address
, pycountry
, html5lib
, six
, kitchen
, pypdf2
, dict2xml
, weasyprint
, pyyaml
, jinja2
, configargparse
, appdirs
}:

buildPythonPackage rec {
  pname = "xml2rfc";
  version = "3.12.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "25deadb9ee95f0dc71376a60e9c1e34636b5016c1952ad5597a6246495e34464";
  };

  propagatedBuildInputs = [
    intervaltree
    jinja2
    pyflakes
    pyyaml
    requests
    lxml
    google-i18n-address
    pycountry
    html5lib
    six
    kitchen
    pypdf2
    dict2xml
    weasyprint
    configargparse
    appdirs
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "jinja2>=2.11,<3.0" "jinja2>=2.11"
  '';

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # lxml tries to fetch from the internet
  doCheck = false;

  pythonImportsCheck = [ "xml2rfc" ];

  meta = with lib; {
    description = "Tool generating IETF RFCs and drafts from XML sources";
    homepage = "https://tools.ietf.org/tools/xml2rfc/trac/";
    # Well, parts might be considered unfree, if being strict; see:
    # http://metadata.ftp-master.debian.org/changelogs/non-free/x/xml2rfc/xml2rfc_2.9.6-1_copyright
    license = licenses.bsd3;
    maintainers = with maintainers; [ vcunat yrashk ];
  };
}
