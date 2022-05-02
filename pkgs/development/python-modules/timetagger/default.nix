{ lib
, python3Packages
, fetchFromGitHub
, pytestCheckHook
, requests
, pytest
, pythonOlder
}:

python3Packages.buildPythonPackage rec {
  pname = "timetagger";
  version = "22.4.2";

  src = fetchFromGitHub {
    owner = "almarklein";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-CWY+5O4Y1dvKQNy1Cclqj4+U6q5vVVj9hZq41MYqXKs=";
  };

  propagatedBuildInputs = with python3Packages; [
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
    pytest
  ];

  # fails with `No module named pytest` on python version 3.10
  doCheck = pythonOlder "3.10";

  meta = with lib; {
    homepage = "https://timetagger.app";
    license = licenses.gpl3Only;
    description = "Tag your time, get the insight";
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
