{ lib
, buildPythonPackage
, fetchPypi
, zope_interface
}:

buildPythonPackage rec {
  pname = "zope.exceptions";
  version = "4.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-YZ0kpMZb7Zez3QUV5zLoK2nxVdQsyUlV0b6MKCiGg80=";
  };

  propagatedBuildInputs = [ zope_interface ];

  # circular deps
  doCheck = false;

  meta = with lib; {
    description = "Exception interfaces and implementations";
    homepage = "https://pypi.python.org/pypi/zope.exceptions";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
