{ stdenv, buildPythonPackage, fetchPypi
, case, pytest, pythonOlder }:

buildPythonPackage rec {
  pname = "vine";
  version = "1.2.0";

  disable = pythonOlder "2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xjz2sjbr5jrpjk411b7alkghdskhphgsqqrbi7abqfh2pli6j7f";
  };

  buildInputs = [ case pytest ];

  meta = with stdenv.lib; {
    description = "Python promises";
    homepage = https://github.com/celery/vine;
    license = licenses.bsd3;
  };
}
