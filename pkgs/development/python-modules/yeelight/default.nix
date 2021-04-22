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
  version = "0.6.1";
  disabled = pythonOlder "3.4";

  src = fetchFromGitLab {
    owner = "stavros";
    repo = "python-yeelight";
    rev = "v${version}";
    sha256 = "sha256-LB7A8E22hyqhVBElrOwtC3IPNkyQkU7ZJ1ScqaXQ6zs=";
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
    license = licenses.asl20;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
