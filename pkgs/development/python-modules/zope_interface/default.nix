{ stdenv
, buildPythonPackage
, fetchPypi
, zope_event
}:

buildPythonPackage rec {
  pname = "zope.interface";
  version = "4.4.3";
  name = "${pname}-${version}";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "d6d26d5dfbfd60c65152938fcb82f949e8dada37c041f72916fef6621ba5c5ce";
  };

  propagatedBuildInputs = [ zope_event ];

  meta = with stdenv.lib; {
    description = "Zope.Interface";
    homepage = http://zope.org/Products/ZopeInterface;
    license = licenses.zpl20;
    maintainers = [ maintainers.goibhniu ];
  };
}
