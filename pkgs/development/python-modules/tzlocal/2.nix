{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pytz
, mock
}:

buildPythonPackage rec {
  pname = "tzlocal";
  version = "2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "643c97c5294aedc737780a49d9df30889321cbe1204eac2c2ec6134035a92e44";
  };

  propagatedBuildInputs = [
    pytz
  ];

  checkInputs = [
    mock
  ];

  doCheck = false;

  pythonImportsCheck = [ "tzlocal" ];

  meta = with lib; {
    description = "Tzinfo object for the local timezone";
    homepage = "https://github.com/regebro/tzlocal";
    license = licenses.cddl;
    maintainers = with maintainers; [ dotlambda ];
  };
}
