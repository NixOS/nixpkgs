{ stdenv
, buildPythonPackage
, fetchPypi
, zope_event
}:

buildPythonPackage rec {
  pname = "zope.interface";
  version = "4.6.0";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "1b3d0dcabc7c90b470e59e38a9acaa361be43b3a6ea644c0063951964717f0e5";
  };

  propagatedBuildInputs = [ zope_event ];

  meta = with stdenv.lib; {
    description = "Zope.Interface";
    homepage = http://zope.org/Products/ZopeInterface;
    license = licenses.zpl20;
    maintainers = [ maintainers.goibhniu ];
  };
}
