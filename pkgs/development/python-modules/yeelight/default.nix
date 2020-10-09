{ lib
, fetchgit
, buildPythonPackage
, pythonOlder
, enum-compat
, future
, ifaddr
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "yeelight";
  version = "0.5.4";

  src = fetchgit {
    url = "https://gitlab.com/stavros/python-yeelight.git";
    rev = "119faeff0d4f9de8c7f6d0580bdecc1c79bcdaea"; # v0.5.4 wasn't tagged
    sha256 = "0j2c5pzd3kny7ghr9q7xn9vs8dffvyzz5igaavvvd04w7aph29sy";
  };

  propagatedBuildInputs = [
    future
    ifaddr
  ] ++ lib.optional (pythonOlder "3.4") enum-compat;

  checkInputs = [
    pytestCheckHook
  ] ++ lib.optional (pythonOlder "3.3") mock;

  pytestFlagsArray = [ "yeelight/tests.py" ];

  pythonImportsCheck = [ "yeelight" ];

  meta = with lib; {
    description = "A Python library for controlling YeeLight RGB bulbs";
    homepage = "https://gitlab.com/stavros/python-yeelight/";
    license = licenses.asl20;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
