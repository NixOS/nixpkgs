{ lib
, Babel
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
  version = "2.0.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05qsaaqfpvr6h4g19prbkpznwb9a4dwzyzivdzh9x80cgkq0r6gb";
  };

  propagatedBuildInputs = [
    Babel
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
