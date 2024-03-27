{ lib
, babel
, buildPythonPackage
, fetchFromGitLab
, pythonRelaxDepsHook
, html2text
, lxml
, packaging
, pillow
, prettytable
, pycountry
, pytestCheckHook
, python-dateutil
, pythonOlder
, pyyaml
, requests
, rich
, setuptools
, testers
, unidecode
, woob
}:

buildPythonPackage rec {
  pname = "woob";
  version = "3.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    owner = "woob";
    repo = "woob";
    rev = version;
    hash = "sha256-M9AjV954H1w64YGCVxDEGGSnoEbmocG3zwltob6IW04=";
  };

  nativeBuildInputs = [
    setuptools
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "packaging"
  ];

  propagatedBuildInputs = [
    babel
    python-dateutil
    html2text
    lxml
    packaging
    pillow
    prettytable
    pycountry
    pyyaml
    requests
    rich
    unidecode
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # require networking
    "test_ciphers"
    "test_verify"
  ];

  pythonImportsCheck = [
    "woob"
  ];

  passthru.tests.version = testers.testVersion {
    package = woob;
    version = "v${version}";
  };

  meta = with lib; {
    changelog = "https://gitlab.com/woob/woob/-/blob/${src.rev}/ChangeLog";
    description = "Collection of applications and APIs to interact with websites";
    mainProgram = "woob";
    homepage = "https://woob.tech";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ DamienCassou ];
  };
}
