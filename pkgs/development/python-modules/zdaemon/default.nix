{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, zconfig
}:

buildPythonPackage rec {
  pname = "zdaemon";
  version = "5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ml7GxRmigLvPqPfnP04Q2AjnuCcQq2COD0Sb88BtQ9U=";
  };

  propagatedBuildInputs = [
    zconfig
  ];

  # too many deps..
  doCheck = false;

  pythonImportsCheck = [
    "zdaemon"
  ];

  meta = with lib; {
    description = "A daemon process control library and tools for Unix-based systems";
    homepage = "https://pypi.python.org/pypi/zdaemon";
    changelog = "https://github.com/zopefoundation/zdaemon/blob/${version}/CHANGES.rst";
    license = licenses.zpl21;
    maintainers = with maintainers; [ goibhniu ];
  };
}
