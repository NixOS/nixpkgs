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
  version = "22.9.3";

  src = fetchFromGitHub {
    owner = "almarklein";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-9YmO0nD6QSFMSXsWlfbRxNWW1nwe7WXinC9pLe7rDEY=";
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

  checkInputs = [
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
