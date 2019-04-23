{ stdenv
, buildPythonPackage
, fetchPypi
, zope_interface
}:

buildPythonPackage rec {
  pname = "zope.proxy";
  version = "4.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "563c2454b2d0f23bca54d2e0e4d781149b7b06cb5df67e253ca3620f37202dd2";
  };

  propagatedBuildInputs = [ zope_interface ];

  # circular deps
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/zopefoundation/zope.proxy;
    description = "Generic Transparent Proxies";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
