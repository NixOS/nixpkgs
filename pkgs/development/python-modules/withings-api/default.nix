{
  lib,
  arrow,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pydantic,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  requests-oauthlib,
  responses,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "withings-api";
  version = "2.4.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "vangorra";
    repo = "python_withings_api";
    tag = version;
    hash = "sha256-8cOLHYnodPGk1b1n6xbVyW2iju3cG6MgnzYTKDsP/nw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'requests-oauth = ">=0.4.1"' '''
  '';

  build-system = [ poetry-core ];

  dependencies = [
    arrow
    requests-oauthlib
    typing-extensions
    pydantic
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "withings_api" ];

  meta = with lib; {
    description = "Library for the Withings Health API";
    homepage = "https://github.com/vangorra/python_withings_api";
    changelog = "https://github.com/vangorra/python_withings_api/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kittywitch ];
    broken = versionAtLeast pydantic.version "2";
  };
}
