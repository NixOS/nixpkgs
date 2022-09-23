{ lib
, babel
, buildPythonApplication
, fetchPypi
, fixtures
, mock
, pbr
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonApplication rec {
  pname = "bashate";
  version = "2.1.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a0df143639715dc2fb6cf9aa6907e4a372d6f0a43afeffc55c5fb3ecfe3523c8";
  };

  propagatedBuildInputs = [
    babel
    pbr
    setuptools
  ];

  checkInputs = [
    fixtures
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bashate" ];

  meta = with lib; {
    description = "Style enforcement for bash programs";
    homepage = "https://opendev.org/openstack/bashate";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
