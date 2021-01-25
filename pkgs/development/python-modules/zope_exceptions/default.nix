{ lib
, buildPythonPackage
, fetchPypi
, zope_interface
}:

buildPythonPackage rec {
  pname = "zope.exceptions";
  version = "4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d72886b1bb8af4c346a117a540f28ab122577f5e3a105a261be72cd15776fda";
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
