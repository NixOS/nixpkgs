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
    tag = "v${version}";
    hash = "sha256-g830TjFERKUguFKlZeaOhCTlaUs0wcDg4bMdRDr3smw=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  enabledTestPaths = [ "statsd/tests.py" ];

<<<<<<< HEAD
  meta = {
    maintainers = [ ];
    description = "Simple statsd client";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    maintainers = [ ];
    description = "Simple statsd client";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/jsocol/pystatsd";
  };
}
