{ lib
, buildPythonPackage
, fetchPypi
, zope-interface
}:

buildPythonPackage rec {
  pname = "zope.proxy";
  version = "4.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1329846261cf6c552b05579f3cfad199b2d178510d0b4703eb5f7cdd6ebad01a";
  };

  propagatedBuildInputs = [ zope-interface ];

  # circular deps
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/zopefoundation/zope.proxy";
    description = "Generic Transparent Proxies";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
