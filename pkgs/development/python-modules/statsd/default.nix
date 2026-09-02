{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "statsd";
  version = "4.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jsocol";
    repo = "pystatsd";
    tag = "v${version}";
    hash = "sha256-g830TjFERKUguFKlZeaOhCTlaUs0wcDg4bMdRDr3smw=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  enabledTestPaths = [ "statsd/tests.py" ];

  meta = {
    maintainers = [ ];
    description = "Simple statsd client";
    license = lib.licenses.mit;
    homepage = "https://github.com/jsocol/pystatsd";
  };
}
