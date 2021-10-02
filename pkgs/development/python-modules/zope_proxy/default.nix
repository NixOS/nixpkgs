{ lib
, buildPythonPackage
, fetchPypi
, zope_interface
}:

buildPythonPackage rec {
  pname = "zope.proxy";
  version = "4.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b244904c5148067c3f1899d29a2c1a28faca747b143192c0f825e6bf3170a347";
  };

  propagatedBuildInputs = [ zope_interface ];

  # circular deps
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/zopefoundation/zope.proxy";
    description = "Generic Transparent Proxies";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
