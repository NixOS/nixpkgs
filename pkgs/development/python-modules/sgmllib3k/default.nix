{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "sgmllib3k";
  version = "1.0.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1s8jm3dgqabgf8x96931scji679qkhvczlv3qld4qxpsicfgns3q";
  };

  doCheck = false;  # No tests.

  meta = with stdenv.lib; {
    homepage = "https://pypi.org/project/sgmllib3k/";
    description = "Py3k port of sgmllib";
    license = licenses.bsd2;
    maintainers = with maintainers; [ delroth ];
  };
}
