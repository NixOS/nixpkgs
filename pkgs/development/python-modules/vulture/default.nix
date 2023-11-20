{ lib
, buildPythonPackage
, fetchPypi
, pint
, pythonOlder
, pytestCheckHook
, toml
}:

buildPythonPackage rec {
  pname = "vulture";
  version = "2.9.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tqKqYytv1RSIqO6sZQq0pQm7GgMugZQ4F6ii5qY6MLM=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov vulture --cov-report=html --cov-report=term --cov-report=xml --cov-append" ""
  '';

  propagatedBuildInputs = [
    toml
  ];

  nativeCheckInputs = [
    pint
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "vulture"
  ];

  meta = with lib; {
    description = "Finds unused code in Python programs";
    homepage = "https://github.com/jendrikseipp/vulture";
    license = licenses.mit;
    maintainers = with maintainers; [ mcwitt ];
  };
}
