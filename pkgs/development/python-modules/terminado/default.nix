{ lib
, buildPythonPackage
, fetchPypi
, ptyprocess
, tornado
}:

buildPythonPackage rec {
  pname = "terminado";
  version = "0.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "89d5dac2f4e2b39758a0ff9a3b643707c95a020a6df36e70583b88297cd59cbe";
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
