{ stdenv
, buildPythonPackage
, fetchPypi
, zope_event
}:

buildPythonPackage rec {
  pname = "zope.interface";
  version = "4.7.2";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "fd1101bd3fcb4f4cf3485bb20d6cb0b56909b94d3bd2a53a6cb9d381c3da3365";
  };

  propagatedBuildInputs = [ zope_event ];

  meta = with stdenv.lib; {
    description = "Zope.Interface";
    homepage = "http://zope.org/Products/ZopeInterface";
    license = licenses.zpl20;
    maintainers = [ maintainers.goibhniu ];
  };
}
