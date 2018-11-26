{ stdenv
, buildPythonPackage
, fetchPypi
, zope_i18nmessageid
, zope_interface
}:

buildPythonPackage rec {
  pname = "zope.size";
  version = "3.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "006xfkhvmypwd3ww9gbba4zly7n9w30bpp1h74d53la7l7fiqk2f";
  };

  propagatedBuildInputs = [ zope_i18nmessageid zope_interface ];

  meta = with stdenv.lib; {
    homepage = http://github.com/zopefoundation/zope.size;
    description = "Interfaces and simple adapter that give the size of an object";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
