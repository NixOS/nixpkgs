{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  itsdangerous,
  python-multipart,
  starlette,
  wtforms,
  httpx,
  jinja2,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "starlette-wtf";
  version = "0.4.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "muicss";
    repo = "starlette-wtf";
    tag = version;
    hash = "sha256-88zU2NAsdty2OhHauwQ5+6LazuRDYPoqN9IIipI1t2Q=";
  };

  nativeBuildInputs = [ setuptools ];
  propagatedBuildInputs = [
    itsdangerous
    python-multipart
    starlette
    wtforms
  ];

  nativeCheckInputs = [
    pytestCheckHook
    httpx
    jinja2
  ];

  meta = with lib; {
    description = "Simple tool for integrating Starlette and WTForms";
    changelog = "https://github.com/muicss/starlette-wtf/blob/v${version}/CHANGELOG.md";
    homepage = "https://github.com/muicss/starlette-wtf";
    license = licenses.mit;
    teams = [ teams.wdz ];
  };
}
