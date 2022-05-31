{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, asgineer
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
  version = "22.4.2";

  src = fetchFromGitHub {
    owner = "almarklein";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-CWY+5O4Y1dvKQNy1Cclqj4+U6q5vVVj9hZq41MYqXKs=";
  };

  propagatedBuildInputs = [
    asgineer
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
