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
, pdm-pep517
, pillow
, prettytable
, python-dateutil
, pythonOlder
, pyyaml
, requests
, termcolor
, testers
, unidecode
, woob
}:

buildPythonPackage rec {
  pname = "woob";
  version = "3.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    owner = "woob";
    repo = pname;
    rev = version;
    hash = "sha256-qVE1FQK3+jBKIHW+s1iNZwy8Srb2kQhWNTlZyzc1/jE=";
  };

  nativeBuildInputs = [
    packaging
    pdm-pep517
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
    pyyaml
    requests
    termcolor
    unidecode
  ];

  patches = [
    (fetchpatch {
      url = "https://gitlab.com/woob/woob/-/commit/861b1bb92be53998d8174dcca6fa643d1c7cde12.patch";
      sha256 = "sha256-IXcE59pMFtPLTOYa2inIvuA14USQvck6Q4hrKZTC0DE=";
    })
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
