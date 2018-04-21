{ lib
, buildPythonPackage
, fetchPypi
, ptyprocess
, tornado
}:

buildPythonPackage rec {
  pname = "terminado";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0yh69k6579g848rmjyllb5h75pkvgcy27r1l3yzgkf33wnnzkasm";
  };

  propagatedBuildInputs = [ ptyprocess tornado ];

  meta = with lib; {
    description = "Terminals served by Tornado websockets";
    homepage = https://github.com/jupyter/terminado;
    license = licenses.bsd2;
  };
}
