{ lib
, python3Packages
, fetchFromGitHub
, pytestCheckHook
, requests
}:

python3Packages.buildPythonPackage rec {
  pname = "timetagger";
  version = "22.1.3";

  src = fetchFromGitHub {
    owner = "almarklein";
    repo = pname;
    rev = "v${version}";
    sha256 = "1x0hy9wnifi694glwv6irhnjvwh1kgl6wn6qlk5qy4x6z6bkii24";
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
  ];

  meta = with lib; {
    homepage = "https://timetagger.app";
    license = licenses.gpl3;
    description = "Tag your time, get the insight";
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
