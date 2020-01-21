{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "zope.contenttype";
  version = "4.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c12d929c67ab3eaef9b8a7fba3d19cce8500c8fd25afed8058c8e15f324cbd5b";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/zopefoundation/zope.contenttype;
    description = "A utility module for content-type (MIME type) handling";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
    broken = true;
  };

}
