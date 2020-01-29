{ stdenv
, buildPythonPackage
, fetchPypi
, zope_interface
}:

buildPythonPackage rec {
  pname = "zope.proxy";
  version = "4.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dac4279aa05055d3897ab5e5ee5a7b39db121f91df65a530f8b1ac7f9bd93119";
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
