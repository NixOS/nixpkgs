{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  testers,
  zpp,
}:
buildPythonPackage rec {
  pname = "zpp";
  version = "1.1.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "jbigot";
    repo = "zpp";
    tag = version;
    hash = "sha256-Jvh80TfOonZ57lb+4PulVOUKi9Y74nplIcrPzlUPw3M=";
  };

  build-system = [ setuptools ];

  passthru = {
    tests.version = testers.testVersion { package = zpp; };
  };

  meta = {
    description = "'Z' pre-processor, the last preprocessor you'll ever need";
    homepage = "https://github.com/jbigot/zpp";
    license = lib.licenses.mit;
    mainProgram = "zpp";
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
