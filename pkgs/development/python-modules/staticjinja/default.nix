{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  poetry-core,
  docopt-ng,
  easywatch,
  jinja2,
  pytestCheckHook,
  pytest-check,
  pythonOlder,
  markdown,
  testers,
  tomlkit,
  typing-extensions,
  staticjinja,
  callPackage,
}:

buildPythonPackage rec {
  pname = "staticjinja";
  version = "5.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  # No tests in pypi
  src = fetchFromGitHub {
    owner = "staticjinja";
    repo = "staticjinja";
    rev = version;
    hash = "sha256-LfJTQhZtnTOm39EWF1m2MP5rxz/5reE0G1Uk9L7yx0w=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    jinja2
    docopt-ng
    easywatch
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-check
    markdown
    tomlkit
    typing-extensions
  ];

  # The tests need to find and call the installed staticjinja executable
  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  passthru.tests = {
    version = testers.testVersion { package = staticjinja; };
    minimal-template = callPackage ./test-minimal-template { };
  };

  meta = with lib; {
    description = "Library and cli tool that makes it easy to build static sites using Jinja2";
    mainProgram = "staticjinja";
    homepage = "https://staticjinja.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}
