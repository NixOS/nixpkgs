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
  version = "23.9.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "almarklein";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-pg4lKRsgi4SZrKYnVmMfU5hzJriRqVa3InYW9emFLy8=";
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
  };
}
