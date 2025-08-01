{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
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

  # The only test fails with:
  #  ImportError: cannot import name 'BadMatchPattern' from 'urlmatch' (/private/tmp/nix-build-python3.12-urlmatch-1.0.0.drv-0/source/urlmatch/__init__.py)
  doCheck = false;

  meta = {
    description = "Python library for easily pattern matching wildcard URLs";
    changelog = "https://github.com/jessepollak/urlmatch/releases/tag/v${version}/CHANGELOG.md";
    homepage = "https://github.com/jessepollak/urlmatch";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
}
