{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "simplefix";
  version = "1.0.17";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    repo = "simplefix";
    owner = "da4089";
    rev = "refs/tags/v${version}";
    hash = "sha256-D85JW3JRQ1xErw6krMbAg94WYjPi76Xqjv/MGNMY5ZU=";
  };

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "simplefix" ];

  unittestFlagsArray = [
    "-s"
    "test"
  ];

  meta = with lib; {
    description = "Simple FIX Protocol implementation for Python";
    homepage = "https://github.com/da4089/simplefix";
    changelog = "https://github.com/da4089/simplefix/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ catern ];
  };
}
