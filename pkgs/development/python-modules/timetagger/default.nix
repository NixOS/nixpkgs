{
  lib,
  asgineer,
  bcrypt,
  buildPythonPackage,
  fetchFromGitHub,
  iptools,
  itemdb,
  jinja2,
  markdown,
  nodejs,
  pscript,
  pyjwt,
  pytestCheckHook,
  pythonOlder,
  requests,
  uvicorn,
}:

buildPythonPackage rec {
  pname = "timetagger";
  version = "24.12.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "almarklein";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-d8O4wmY3eJ2HrHq6SKEoaXYAh+A+hWpN72Zfw6WyC1g=";
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
    mainProgram = "timetagger";
    homepage = "https://github.com/almarklein/timetagger";
    changelog = "https://github.com/almarklein/timetagger/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
