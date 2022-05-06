{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
}:

buildPythonPackage rec {
  pname = "suds-jurko";
  version = "0.6";
  disabled = isPyPy;  # lots of failures

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1s4radwf38kdh3jrn5acbidqlr66sx786fkwi0rgq61hn4n2bdqw";
  };

  doCheck = false;

  postPatch = ''
    # fails
    substituteInPlace tests/test_transport_http.py \
      --replace "test_sending_unicode_data" "noop"
  '';

  meta = with lib; {
    description = "Lightweight SOAP client (Jurko's fork)";
    homepage = "https://bitbucket.org/jurko/suds";
    license = licenses.lgpl3;
    broken = true; # Uses use2to3, which has been removed in setuptools>=58
  };

}
