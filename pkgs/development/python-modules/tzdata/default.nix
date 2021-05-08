{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
, pytest-subtests
, importlib-resources
}:

buildPythonPackage rec {
  pname = "tzdata";
  version = "2021.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4ZxzUfiHUioaxznSEEHlkt3ebdG3ZP3vqPeys1UdPTg=";
  };

  checkInputs = [
    pytestCheckHook
    pytest-subtests
  ] ++ lib.optional (pythonOlder "3.7") importlib-resources;

  pythonImportsCheck = [ "tzdata" ];

  meta = with lib; {
    description = "Provider of IANA time zone data";
    homepage = "https://github.com/python/tzdata";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
