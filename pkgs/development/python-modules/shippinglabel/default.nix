{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, apeye
, deprecation-alias
, dist-meta
, dom-toml
, domdf-python-tools
, packaging
, platformdirs
, typing-extensions
, betamax
, pytest-regressions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "shippinglabel";
  version = "1.7.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "domdfcoding";
    repo = "shippinglabel";
    rev = "v${version}";
    hash = "sha256-vwOf5QWUsy4CaukRI0r3Ktfd/TSBR2eVUv8J9+HHMXE=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    apeye
    deprecation-alias
    dist-meta
    dom-toml
    domdf-python-tools
    packaging
    platformdirs
    typing-extensions
  ];

  pythonImportsCheck = [ "shippinglabel" ];

  nativeCheckInputs = [
    betamax
    pytest-regressions
    pytestCheckHook
  ];

  # requires coincidence which hasn't been packaged yet
  doCheck = false;

  meta = with lib; {
    description = "Utilities for handling packages";
    homepage = "https://github.com/domdfcoding/shippinglabel";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
