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
<<<<<<< HEAD
, rich
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, termcolor
, testers
, unidecode
, woob
}:

buildPythonPackage rec {
  pname = "woob";
<<<<<<< HEAD
  version = "3.6";
=======
  version = "3.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    owner = "woob";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-M9AjV954H1w64YGCVxDEGGSnoEbmocG3zwltob6IW04=";
=======
    hash = "sha256-Yb3AgUSqr9r2TIymiEUIhKThNC7yjQEkhi8GSI9fqNA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    rich
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
