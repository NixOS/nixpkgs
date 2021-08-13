{ lib
, buildPythonPackage
, fetchFromGitLab
, future
, ifaddr
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "yeelight";
  version = "0.7.2";
  disabled = pythonOlder "3.4";

  src = fetchFromGitLab {
    owner = "stavros";
    repo = "python-yeelight";
    rev = "v${version}";
    sha256 = "06pg5q50dw5a0h6jnln8419asi8nahzvlk0s65ymykqq0jxac31y";
  };

  propagatedBuildInputs = [
    future
    ifaddr
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [ "yeelight/tests.py" ];

  pythonImportsCheck = [ "yeelight" ];

  meta = with lib; {
    description = "Python library for controlling YeeLight RGB bulbs";
    homepage = "https://gitlab.com/stavros/python-yeelight/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
