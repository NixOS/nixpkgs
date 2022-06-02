{ lib
, buildPythonPackage
, fetchPypi
, zope_testing
}:

buildPythonPackage rec {
  pname = "zope-hookable";
  version = "5.1.0";

  src = fetchPypi {
    pname = "zope.hookable";
    inherit version;
    sha256 = "8fc3e6cd0486c6af48e3317c299def719b57538332a194e0b3bc6a772f4faa0e";
  };

  checkInputs = [ zope_testing ];

  meta = with lib; {
    description = "Supports the efficient creation of “hookable” objects";
    homepage = "https://github.com/zopefoundation/zope.hookable";
    license = licenses.zpl21;
  };
}
