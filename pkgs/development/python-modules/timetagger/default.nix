{ lib
, stdenv
, asgineer
, bcrypt
, buildPythonPackage
, fetchFromGitHub
, iptools
, itemdb
, jinja2
, markdown
, nodejs
, pscript
, pyjwt
, pytestCheckHook
, pythonOlder
, requests
, uvicorn
}:

buildPythonPackage rec {
  pname = "timetagger";
<<<<<<< HEAD
  version = "23.9.2";
=======
  version = "23.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "almarklein";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-pg4lKRsgi4SZrKYnVmMfU5hzJriRqVa3InYW9emFLy8=";
=======
    hash = "sha256-X0FeRyybomuOitpTldQTRlH3UeEs16ZYdYa/mu7mSGo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    asgineer
    bcrypt
    iptools
    itemdb
    jinja2
    markdown
    pscript
    pyjwt
    uvicorn
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  nativeCheckInputs = [
    nodejs
    pytestCheckHook
    requests
  ];

  meta = with lib; {
    description = "Library to interact with TimeTagger";
    homepage = "https://github.com/almarklein/timetagger";
    changelog = "https://github.com/almarklein/timetagger/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ matthiasbeyer ];
<<<<<<< HEAD
=======
    broken = stdenv.isDarwin;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
