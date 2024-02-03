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
, testtools
}:

buildPythonApplication rec {
  pname = "bashate";
  version = "2.1.1";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-S6tul3+DBacgU1+Pk/H7QsUh/LxKbCs9PXZx9C8iH0w=";
  };

  propagatedBuildInputs = [
    babel
    pbr
    setuptools
  ];

  nativeCheckInputs = [
    fixtures
    mock
    pytestCheckHook
    testtools
  ];

  pythonImportsCheck = [ "bashate" ];

  meta = with lib; {
    description = "Style enforcement for bash programs";
    homepage = "https://opendev.org/openstack/bashate";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
