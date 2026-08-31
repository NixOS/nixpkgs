{
  buildPythonPackage,
  fetchFromGitHub,
  lib,

  # build-system
  setuptools,

  # dependencies
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "stcrestclient";
  version = "1.9.8";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Viavi-TestCenter";
    repo = "py-stcrestclient";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fQ3TF/ub5gGZetdUrKTA2HbrxM7HO/05ZlJKhbq1Qbc=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  pythonImportsCheck = [ "stcrestclient" ];

  meta = {
    changelog = "https://github.com/Viavi-TestCenter/py-stcrestclient/releases/tag/${finalAttrs.src.tag}";
    description = "Client modules for the Spirent TestCenter (STC) ReST API";
    homepage = "https://github.com/Viavi-TestCenter/py-stcrestclient";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      de11n
      despsyched
    ];
  };
})
