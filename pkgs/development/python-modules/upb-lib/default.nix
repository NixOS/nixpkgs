{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pyserial-asyncio
, pytz
}:

buildPythonPackage rec {
  pname = "upb-lib";
  version = "0.4.12";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e668055d9c389aefd09203afb96a950a320095f225ef0a1aa611e592db92a71b";
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
