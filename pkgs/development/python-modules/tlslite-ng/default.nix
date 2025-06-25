{
  lib,
  buildPythonPackage,
  ecdsa,
  fetchFromGitHub,
  hypothesis,
  pytestCheckHook,
  pythonAtLeast,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tlslite-ng";
  version = "0.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tlsfuzzer";
    repo = "tlslite-ng";
    tag = "v${version}";
    hash = "sha256-lKSFPJ4Dm8o1zUgvXjUUpStV5M+xf7s6wOg2ceYbpbw=";
  };

  build-system = [ setuptools ];

  dependencies = [ ecdsa ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  # This file imports asyncore which is removed in 3.12
  disabledTestPaths = lib.optionals (pythonAtLeast "3.12") [
    "tlslite/integration/tlsasyncdispatchermixin.py"
  ];

  meta = with lib; {
    description = "Implementation of SSL and TLS";
    homepage = "https://github.com/tlsfuzzer/tlslite-ng";
    changelog = "https://github.com/tlsfuzzer/tlslite-ng/releases/tag/${src.tag}";
    license = licenses.lgpl21Only;
    maintainers = [ ];
  };
}
