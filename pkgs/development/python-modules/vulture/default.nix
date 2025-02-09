{ lib
, buildPythonPackage
, fetchPypi
, pint
, pytestCheckHook
, pythonOlder
, setuptools
, toml
, tomli
}:

buildPythonPackage rec {
  pname = "vulture";
  version = "2.10";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KlwxYL/7p3WVtubfzEEgFr0qCc1LZs33+7qRNoSJn28=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov vulture --cov-report=html --cov-report=term --cov-report=xml --cov-append" ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  nativeCheckInputs = [
    pint
    pytestCheckHook
    toml
  ];

  pythonImportsCheck = [
    "vulture"
  ];

  meta = with lib; {
    description = "Finds unused code in Python programs";
    homepage = "https://github.com/jendrikseipp/vulture";
    changelog = "https://github.com/jendrikseipp/vulture/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ mcwitt ];
  };
}
