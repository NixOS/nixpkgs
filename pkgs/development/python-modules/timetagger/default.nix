{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, asgineer
, bcrypt
, itemdb
, jinja2
, markdown
, pscript
, pyjwt
, uvicorn
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "timetagger";
  version = "23.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "almarklein";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-QICn7Ugnac2nu7I4xDWyujvloCiz70XnqA7SJbopR5s=";
  };

  propagatedBuildInputs = [
    asgineer
    bcrypt
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
    pytestCheckHook
    requests
  ];

  meta = with lib; {
    description = "Library to interact with TimeTagger";
    homepage = "https://github.com/almarklein/timetagger";
    changelog = "https://github.com/almarklein/timetagger/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ matthiasbeyer ];
    broken = stdenv.isDarwin;
  };
}
