{ stdenv
, buildPythonPackage
, fetchPypi
, zope_interface
}:

buildPythonPackage rec {
  pname = "zope.proxy";
  version = "4.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ab6d6975d9c51c13cac828ff03168de21fb562b0664c59bcdc4a4b10f39a5b17";
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
