{ stdenv
, buildPythonPackage
, fetchPypi
, zope_interface
}:

buildPythonPackage rec {
  pname = "zope.broken";
  version = "3.6.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "b9b8776002da4f7b6b12dfcce77eb642ae62b39586dbf60e1d9bdc992c9f2999";
  };

  buildInputs = [ zope_interface ];

  meta = with stdenv.lib; {
    homepage = http://pypi.python.org/pypi/zope.broken;
    description = "Zope Broken Object Interfaces";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
