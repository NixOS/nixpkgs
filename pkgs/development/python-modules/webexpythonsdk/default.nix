{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyjwt,
  requests,
  requests-toolbelt,
  poetry-core,
  poetry-dynamic-versioning,
  pyprojectVersionPatchHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "webexpythonsdk";
  version = "2.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "WebexCommunity";
    repo = "WebexPythonSDK";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2yyGR5gCJVRsEnoPAr8tkMeG19vTfATl/ybuMydnplU=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [
    pyjwt
    requests
    requests-toolbelt
  ];

  # Tests require a Webex Teams test domain
  doCheck = false;

  pythonImportsCheck = [ "webexpythonsdk" ];

  meta = {
    description = "Python module for Webex Teams APIs";
    homepage = "https://github.com/WebexCommunity/WebexPythonSDK";
    changelog = "https://github.com/WebexCommunity/WebexPythonSDK/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
