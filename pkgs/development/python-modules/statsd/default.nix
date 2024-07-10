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
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jsocol";
    repo = "pystatsd";
    rev = "refs/tags/v${version}";
    hash = "sha256-g830TjFERKUguFKlZeaOhCTlaUs0wcDg4bMdRDr3smw=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pytestFlagsArray = [ "statsd/tests.py" ];

  meta = with lib; {
    maintainers = with maintainers; [ domenkozar ];
    description = "Simple statsd client";
    license = licenses.mit;
    homepage = "https://github.com/jsocol/pystatsd";
  };
}
