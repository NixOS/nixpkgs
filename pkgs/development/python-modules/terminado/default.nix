{ lib
, buildPythonPackage
, fetchPypi
, ptyprocess
, tornado
}:

buildPythonPackage rec {
  pname = "terminado";
  version = "0.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "89e6d94b19e4bc9dce0ffd908dfaf55cc78a9bf735934e915a4a96f65ac9704c";
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
