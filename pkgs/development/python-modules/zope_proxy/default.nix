{ lib
, buildPythonPackage
, fetchPypi
, zope_interface
}:

buildPythonPackage rec {
  pname = "zope.proxy";
  version = "5.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-b6RMl6QStNxR4vX9Tcc8W9SZ01KA+IzSvNJviuHkV3s=";
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
