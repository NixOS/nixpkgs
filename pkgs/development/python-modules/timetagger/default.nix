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
, requests
}:

buildPythonPackage rec {
  pname = "timetagger";
  version = "23.2.1";

  src = fetchFromGitHub {
    owner = "almarklein";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-QICn7Ugnac2nu7I4xDWyujvloCiz70XnqA7SJbopR5s=";
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
    broken = stdenv.isDarwin;
    homepage = "https://timetagger.app";
    license = licenses.gpl3Only;
    description = "Tag your time, get the insight";
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
