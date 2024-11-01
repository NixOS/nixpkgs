{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  arrow,
  requests-oauthlib,
  typing-extensions,
  pydantic,
  responses,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "withings-api";
  version = "2.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "vangorra";
    repo = "python_withings_api";
    rev = "refs/tags/${version}";
    hash = "sha256-8cOLHYnodPGk1b1n6xbVyW2iju3cG6MgnzYTKDsP/nw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'requests-oauth = ">=0.4.1"' ''' \
      --replace 'addopts = "--capture no --cov ./withings_api --cov-report html:build/coverage_report --cov-report term --cov-report xml:build/coverage.xml"' '''
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    arrow
    requests-oauthlib
    typing-extensions
    pydantic
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  meta = with lib; {
    description = "Library for the Withings Health API";
    homepage = "https://github.com/vangorra/python_withings_api";
    license = licenses.mit;
    maintainers = with maintainers; [ kittywitch ];
    broken = versionAtLeast pydantic.version "2";
  };
}
