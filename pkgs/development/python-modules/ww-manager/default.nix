{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  typer,
  certifi,
  rich,
  typing-extensions,
  pythonOlder,
  testers,
}:

buildPythonPackage (finalAttrs: {
  __structuredAttrs = true;
  pname = "ww-manager";
  version = "2.1.12";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "timetetng";
    repo = "wutheringwaves-cli-manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1BYcPAzsFVUHXHqPKOLrQwTEJcX4OIxAkJDMN3BNS3M=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    certifi
    rich
    typer
    typing-extensions
  ];

  # upstream ships no tests
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "ww --version";
  };

  pythonImportsCheck = [
    "ww_manager"
  ];

  meta = {
    description = "Wuthering Waves CLI Manager";
    homepage = "https://github.com/timetetng/wutheringwaves-cli-manager";
    changelog = "https://github.com/timetetng/wutheringwaves-cli-manager/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.yefada ];
    mainProgram = "ww";
  };
})
