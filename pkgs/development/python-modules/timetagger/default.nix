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
  version = "22.2.3";

  src = fetchFromGitHub {
    owner = "almarklein";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tQel+IVqP+MngAvFgr7Yh+XCSIPWpzCBXHOj9b0Os98=";
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
