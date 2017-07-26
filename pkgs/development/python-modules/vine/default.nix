{ stdenv, buildPythonPackage, fetchPypi
, case, pytest, pythonOlder }:

buildPythonPackage rec {
  pname = "vine";
  version = "1.1.3";
  name = "${pname}-${version}";

  disable = pythonOlder "2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0h94x9mc9bspg23lb1f73h7smdzc39ps7z7sm0q38ds9jahmvfc7";
  };

  buildInputs = [ case pytest ];

  meta = with stdenv.lib; {
    description = "Python promises";
    homepage = https://github.com/celery/vine;
    license = licenses.bsd3;
  };
}
