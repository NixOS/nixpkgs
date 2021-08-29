{ lib
, buildPythonPackage
, fetchPypi
, zope_testing
}:

buildPythonPackage rec {
  pname = "zope-hookable";
  version = "5.0.1";

  src = fetchPypi {
    pname = "zope.hookable";
    inherit version;
    sha256 = "0hc82lfr7bk53nvbxvjkibkarngyrzgfk2i6bg8wshl0ly0pdl19";
  };

  checkInputs = [ zope_testing ];

  meta = with lib; {
    description = "Supports the efficient creation of “hookable” objects";
    homepage = "https://github.com/zopefoundation/zope.hookable";
    license = licenses.zpl21;
  };
}
