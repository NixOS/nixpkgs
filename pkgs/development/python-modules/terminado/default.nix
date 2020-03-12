{ lib
, buildPythonPackage
, fetchPypi
, ptyprocess
, tornado
}:

buildPythonPackage rec {
  pname = "terminado";
  version = "0.8.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4804a774f802306a7d9af7322193c5390f1da0abb429e082a10ef1d46e6fb2c2";
  };

  propagatedBuildInputs = [ ptyprocess tornado ];

  # test_max_terminals fails
  doCheck = false;

  meta = with lib; {
    description = "Terminals served by Tornado websockets";
    homepage = https://github.com/jupyter/terminado;
    license = licenses.bsd2;
  };
}
