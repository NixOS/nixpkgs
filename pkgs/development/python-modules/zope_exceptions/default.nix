{ lib
, buildPythonPackage
, fetchPypi
, zope_interface
}:

buildPythonPackage rec {
  pname = "zope.exceptions";
  version = "4.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-TjW7oEiJxdEU3KpVKXQl1fM/YYqF7323Ehs7dxEAeE4=";
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
