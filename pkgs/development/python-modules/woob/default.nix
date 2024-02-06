{ lib
, babel
, buildPythonPackage
, fetchFromGitLab
, fetchpatch
, gnupg
, html2text
, libyaml
, lxml
, nose
, packaging
, pillow
, prettytable
, pycountry
, python-dateutil
, pythonOlder
, pyyaml
, requests
, rich
, termcolor
, testers
, unidecode
, woob
}:

buildPythonPackage rec {
  pname = "woob";
  version = "3.6";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    owner = "woob";
    repo = pname;
    rev = version;
    hash = "sha256-M9AjV954H1w64YGCVxDEGGSnoEbmocG3zwltob6IW04=";
  };

  nativeBuildInputs = [
    packaging
  ];

  propagatedBuildInputs = [
    babel
    python-dateutil
    gnupg
    html2text
    libyaml
    lxml
    packaging
    pillow
    prettytable
    pycountry
    pyyaml
    requests
    rich
    termcolor
    unidecode
  ];

  nativeCheckInputs = [
    nose
  ];

  checkPhase = ''
    nosetests
  '';

  pythonImportsCheck = [
    "woob"
  ];

  passthru.tests.version = testers.testVersion {
    package = woob;
    version = "v${version}";
  };

  meta = with lib; {
    description = "Collection of applications and APIs to interact with websites";
    homepage = "https://woob.tech";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ DamienCassou ];
  };
}
