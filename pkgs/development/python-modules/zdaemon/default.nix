{ lib
, buildPythonPackage
, fetchPypi
, zconfig
}:

buildPythonPackage rec {
  pname = "zdaemon";
  version = "4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-SCHjvbRzh88eklWwREusQ3z3KqC1nRQHuTLjH9QyPvw=";
  };

  propagatedBuildInputs = [ zconfig ];

  # too many deps..
  doCheck = false;

  meta = with lib; {
    description = "A daemon process control library and tools for Unix-based systems";
    homepage = "https://pypi.python.org/pypi/zdaemon";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
