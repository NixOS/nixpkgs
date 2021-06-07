{ lib, buildPythonPackage, fetchPypi
, case, pytest, pythonOlder }:

buildPythonPackage rec {
  pname = "vine";
  version = "5.0.0";

  disable = pythonOlder "2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7d3b1624a953da82ef63462013bbd271d3eb75751489f9807598e8f340bd637e";
  };

  buildInputs = [ case pytest ];

  meta = with lib; {
    description = "Python promises";
    homepage = "https://github.com/celery/vine";
    license = licenses.bsd3;
  };
}
