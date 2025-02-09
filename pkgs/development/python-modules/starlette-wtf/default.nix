{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, itsdangerous
, python-multipart
, starlette
, wtforms
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "starlette-wtf";
  version = "0.4.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "muicss";
    repo = "starlette-wtf";
    rev = "v${version}";
    hash = "sha256-TSxcIgINRjQwiyhpGOEEpXJKcPlhFCxMQh4/GY1g1lw=";
  };

  nativeBuildInputs = [
    setuptools
  ];
  propagatedBuildInputs = [
    itsdangerous
    python-multipart
    starlette
    wtforms
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A simple tool for integrating Starlette and WTForms";
    changelog = "https://github.com/muicss/starlette-wtf/blob/v${version}/CHANGELOG.md";
    homepage = "https://github.com/muicss/starlette-wtf";
    license = licenses.mit;
    maintainers = teams.wdz.members;
  };
}
