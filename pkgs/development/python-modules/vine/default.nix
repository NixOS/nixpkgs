{ stdenv, buildPythonPackage, fetchPypi
, case, pytest, pythonOlder }:

buildPythonPackage rec {
  pname = "vine";
  version = "1.1.4";
  name = "${pname}-${version}";

  disable = pythonOlder "2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "52116d59bc45392af9fdd3b75ed98ae48a93e822cee21e5fda249105c59a7a72";
  };

  buildInputs = [ case pytest ];

  meta = with stdenv.lib; {
    description = "Python promises";
    homepage = https://github.com/celery/vine;
    license = licenses.bsd3;
  };
}
