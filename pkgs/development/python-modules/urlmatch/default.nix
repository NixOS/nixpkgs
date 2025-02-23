{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "urlmatch";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jessepollak";
    repo = "urlmatch";
    tag = "v${version}";
    hash = "sha256-vNt3SdIIno1XPO9zrTHXw6YSrE1oOWdkN3fszQnR8I0=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "urlmatch" ];

  meta = {
    description = "Python library for easily pattern matching wildcard URLs";
    changelog = "https://github.com/jessepollak/urlmatch/releases/tag/v${version}/CHANGELOG.md";
    homepage = "https://github.com/jessepollak/urlmatch";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
}
