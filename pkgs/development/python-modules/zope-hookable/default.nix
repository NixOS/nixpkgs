{ lib
, buildPythonPackage
, fetchPypi
, zope_testing
}:

buildPythonPackage rec {
  pname = "zope-hookable";
  version = "4.2.0";

  src = fetchPypi {
    pname = "zope.hookable";
    inherit version;
    sha256 = "c1df3929a3666fc5a0c80d60a0c1e6f6ef97c7f6ed2f1b7cf49f3e6f3d4dde15";
  };

  checkInputs = [ zope_testing ];

  meta = with lib; {
    description = "Supports the efficient creation of “hookable” objects";
    homepage = http://github.com/zopefoundation/zope.hookable;
    license = licenses.zpl21;
  };
}
