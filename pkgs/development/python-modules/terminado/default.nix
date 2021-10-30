{ lib
, buildPythonPackage
, fetchPypi
, ptyprocess
, tornado
}:

buildPythonPackage rec {
  pname = "terminado";
  version = "0.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "962b402edbb480718054dc37027bada293972ecadfb587b89f01e2b8660a2132";
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
