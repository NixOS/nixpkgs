{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pyserial-asyncio
, pytz
}:

buildPythonPackage rec {
  pname = "upb-lib";
  version = "0.5.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "upb_lib";
    inherit version;
    hash = "sha256-KEnSADj+sQtz37Xbi6fXoe2TN+F5Z9SYnlvCgXtxVnk=";
  };

  propagatedBuildInputs = [
    pyserial-asyncio
    pytz
  ];

  # no tests on PyPI, no tags on GitHub
  doCheck = false;

  pythonImportsCheck = [ "upb_lib" ];

  meta = with lib; {
    description = "Library for interacting with UPB PIM";
    homepage = "https://github.com/gwww/upb-lib";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
