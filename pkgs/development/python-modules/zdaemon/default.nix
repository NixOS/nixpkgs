{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, zconfig
}:

buildPythonPackage rec {
  pname = "zdaemon";
  version = "4.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SCHjvbRzh88eklWwREusQ3z3KqC1nRQHuTLjH9QyPvw=";
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
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };
}
