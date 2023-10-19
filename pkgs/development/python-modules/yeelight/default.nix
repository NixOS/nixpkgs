{ lib
, async-timeout
, buildPythonPackage
, fetchFromGitLab
, flit-core
, future
, ifaddr
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "yeelight";
  version = "0.7.13";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    owner = "stavros";
    repo = "python-yeelight";
    rev = "refs/tags/v${version}";
    hash = "sha256-IhEvyWgOTAlfQH1MX7GCpaJUJOGY/ZNbyk5Q6CiTDLA=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    future
    ifaddr
  ] ++ lib.optionals (pythonOlder "3.11") [
    async-timeout
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "yeelight/tests.py"
  ];

  pythonImportsCheck = [
    "yeelight"
  ];

  meta = with lib; {
    description = "Python library for controlling YeeLight RGB bulbs";
    homepage = "https://gitlab.com/stavros/python-yeelight/";
    changelog = "https://gitlab.com/stavros/python-yeelight/-/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
