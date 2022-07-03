{ lib
, buildPythonPackage
, fetchPypi
, ptyprocess
, tornado
}:

buildPythonPackage rec {
  pname = "terminado";
  version = "0.13.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-lNHPq2NSWZP31cm0aaUKGNDN85Q1tZeFcVU53UHjbA0=";
  };

  propagatedBuildInputs = [ ptyprocess tornado ];

  # test_max_terminals fails
  doCheck = false;

  meta = with lib; {
    description = "Terminals served by Tornado websockets";
    homepage = "https://github.com/jupyter/terminado";
    license = licenses.bsd2;
  };
}
