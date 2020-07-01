{ stdenv, buildPythonPackage, fetchPypi
, case, pytest, pythonOlder }:

buildPythonPackage rec {
  pname = "vine";
  version = "1.3.0";

  disable = pythonOlder "2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "133ee6d7a9016f177ddeaf191c1f58421a1dcc6ee9a42c58b34bed40e1d2cd87";
  };

  buildInputs = [ case pytest ];

  meta = with stdenv.lib; {
    description = "Python promises";
    homepage = "https://github.com/celery/vine";
    license = licenses.bsd3;
  };
}
