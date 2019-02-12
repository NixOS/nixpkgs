{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "zope.event";
  version = "4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "69c27debad9bdacd9ce9b735dad382142281ac770c4a432b533d6d65c4614bcf";
  };

  meta = with stdenv.lib; {
    description = "An event publishing system";
    homepage = https://pypi.python.org/pypi/zope.event;
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
