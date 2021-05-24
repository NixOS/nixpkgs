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
  version = "0.6.2";
  disabled = pythonOlder "3.4";

  src = fetchFromGitLab {
    owner = "stavros";
    repo = "python-yeelight";
    rev = "v${version}";
    sha256 = "0v0i0s8d5z6b63f2sy42wf85drdzrzswlm1hknzr7v6lfr52pwwm";
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
