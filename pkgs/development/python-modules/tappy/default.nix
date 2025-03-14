{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools,
  pyyaml,
  more-itertools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tap.py";
  version = "3.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PAzUUhKtWiWzVEWWTiUX76AAoRihv8NDfa6CiJLq8eE=";
  };

  build-system = [
    setuptools
  ];

  optional-dependencies = {
    yaml = [
      pyyaml
      more-itertools
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "tap" ];

  meta = with lib; {
    description = "Set of tools for working with the Test Anything Protocol (TAP) in Python";
    homepage = "https://github.com/python-tap/tappy";
    changelog = "https://tappy.readthedocs.io/en/latest/releases.html";
    mainProgram = "tappy";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sfrijters ];
  };
}
