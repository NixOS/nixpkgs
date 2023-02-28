{ lib
, buildPythonPackage
, fetchPypi
, zope_interface
}:

buildPythonPackage rec {
  pname = "zope.proxy";
  version = "4.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+xUTt6jtc3oxI/1XHCRPB+7iRdYIGlY3CyBhHUAPCXQ=";
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
